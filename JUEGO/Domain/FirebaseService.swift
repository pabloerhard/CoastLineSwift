//
//  TutorRepository.swift
//  JUEGO
//
//  Created by Alumno on 6/2/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage



class FirebaseService{
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    func signIn(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                completion(.success(user.uid))
            } else {
                let unknownError = NSError(domain: "firebase.google.com", code: -1, userInfo: nil)
                completion(.failure(unknownError))
            }
        }
    }
    
    func register(email: String, password: String, nombre: String, apellido: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                completion(.success(user.uid))
            } else {
                let unknownError = NSError(domain: "firebase.google.com", code: -1, userInfo: nil)
                completion(.failure(unknownError))
            }
        }
    }
                
    func insertTutor(tutor: Tutor){
        let tutorRef = Firestore.firestore().collection("tutores")
        let data = [
            "Nombre": tutor.Nombre,
            "Apellido": tutor.Apellido
        ]
        if let tutorId = tutor.Id {
            tutorRef.document(tutorId).setData(data) { error in
                if let error = error {
                    print("Error inserting document: \(error.localizedDescription)")
                } else {
                    print("Document inserted with ID: \(tutorId)")
                }
            }
        }
    }
    	
    func getTutor(documentId: String, completion: @escaping (Result<Tutor, Error>) -> Void) {
        let docRef = db.collection("tutores").document(documentId)

        docRef.getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let document = document, document.exists, let data = document.data() else {
                // Document doesn't exist or unable to retrieve data
                completion(.failure(NSError(domain: "firebase.google.com/tutores", code: FirestoreErrorCode.notFound.rawValue, userInfo: [NSLocalizedDescriptionKey: "Document doesn't exist or unable to retrieve data"])))
                return
            }

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                let tutor = try JSONDecoder().decode(Tutor.self, from: jsonData)
                completion(.success(tutor))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getTutorAlumnos(tutorId: String) async throws -> [Alumno] {
        let alumnosRef = db.collection("alumnos")
        let query = alumnosRef.whereField("Tutores", arrayContains: tutorId)
        let querySnapshot = try await query.getDocuments()
        let documents = querySnapshot.documents
        var alumnos = [Alumno]()
        
        for document in documents {
            let data = document.data()
            if  let nombre = data["Nombre"] as? String,
                let apellido = data["Apellido"] as? String,
                let nivel = data["Nivel"] as? Int,
                let tutores = data["Tutores"] as? [String],
                let pictogramas = data["Pictogramas"] as? [[String: String]] {
                
                var pictos = [Pictograma]()
                pictogramas.forEach { pictoData in
                    if let nombre = pictoData["Nombre"],
                       let url = pictoData["Url"] {
                        let picto = Pictograma(Nombre: nombre, Image: url)
                        pictos.append(picto)
                        print(picto)
                    }
                }
                let alumno = Alumno(Id: document.documentID, Nombre: nombre, Apellido: apellido, Nivel: nivel, Tutores: tutores, Pictogramas: pictos)
                alumnos.append(alumno)
            }
        }
        return alumnos
    }
    
    func getAlumnos() async throws -> [Alumno] {
        let alumnosRef = db.collection("alumnos")
        let querySnapshot = try await alumnosRef.getDocuments()
        let documents = querySnapshot.documents
        var alumnos = [Alumno]()
        
        for document in documents {
            let data = document.data()
            if  let nombre = data["Nombre"] as? String,
                let apellido = data["Apellido"] as? String,
                let nivel = data["Nivel"] as? Int,
                let tutores = data["Tutores"] as? [String],
                let pictogramas = data["Pictogramas"] as? [[String: String]] {
                
                var pictos = [Pictograma]()
                pictogramas.forEach { pictoData in
                    if let nombre = pictoData["Nombre"],
                       let url = pictoData["Url"] {
                        let picto = Pictograma(Nombre: nombre, Image:url)
                        pictos.append(picto)
                        print(picto)
                    }
                }
                let alumno = Alumno(Id: document.documentID, Nombre: nombre, Apellido: apellido, Nivel: nivel, Tutores: tutores, Pictogramas: pictos)
                alumnos.append(alumno)
            }
        }
        return alumnos
    }
    
    /*func updateAlumno(userData: UserData, nombre: String, url: String) async throws -> Alumno {
        let alumnosRef = db.collection("alumnos")
        let documentRef = alumnosRef.document(userData.curAlumno.Id)
        let document = try await documentRef.getDocument()
        
        
        
        if let data = document.data(){
            var pictogramas = data["Pictogramas"] as? [[String: String]] ?? []
            let updatedPictogramas = pictogramas.map { pictograma -> [String: String] in
                var updatedPictograma = pictograma
                if let docNombre = pictograma["Nombre"], docNombre == nombre {
                    updatedPictograma["Url"] = url
                }
                return updatedPictograma
            }
            
        }
        return Alumno
    }*/
    
    func addImageToStorage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        let filename = UUID().uuidString
        let ref = storage.reference(withPath: filename)
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            ref.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(url?.absoluteString ?? ""))
            }
            
        }
    }
    
    
    func signOut() throws {
            try Auth.auth().signOut()
        }
}
