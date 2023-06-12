//
//  TutorRepository.swift
//  JUEGO
//
//  Created by Alumno on 6/2/23.
//

import Foundation
import Firebase
import FirebaseFirestore


class FirebaseService{
    let db = Firestore.firestore()
    
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
    
    func getTutorAlumnos(tutorId: String) async throws -> Set<Alumno> {
        let alumnosRef = db.collection("alumnos")
        let query = alumnosRef.whereField("Tutores", arrayContains: tutorId)
        let querySnapshot = try await query.getDocuments()
        let documents = querySnapshot.documents
        var alumnos = Set<Alumno>()
        
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
                        let picto = Pictograma(Nombre: nombre, Url: url)
                        pictos.append(picto)
                        print(picto)
                    }
                }
                let alumno = Alumno(Id: document.documentID, Nombre: nombre, Apellido: apellido, Nivel: nivel, Tutores: tutores, Pictogramas: pictos)
                alumnos.insert(alumno)
            }
        }
        return alumnos
    }
    
    func getAlumnos() async throws -> Set<Alumno> {
        let alumnosRef = db.collection("alumnos")
        let querySnapshot = try await alumnosRef.getDocuments()
        let documents = querySnapshot.documents
        var alumnos = Set<Alumno>()
        
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
                        let picto = Pictograma(Nombre: nombre, Url: url)
                        pictos.append(picto)
                        print(picto)
                    }
                }
                let alumno = Alumno(Id: document.documentID, Nombre: nombre, Apellido: apellido, Nivel: nivel, Tutores: tutores, Pictogramas: pictos)
                alumnos.insert(alumno)
            }
        }
        return alumnos
    }
    
    
    func signOut() throws {
            try Auth.auth().signOut()
        }
    
    func deleteUser() throws {
        let user = Auth.auth().currentUser
        user?.delete { error in
          if let error = error {
              print("error borrando usuario: \(error.localizedDescription)")
          } else {
              print("se borro el usuario: \(user?.email)")
          }
        }
        
    }
}
