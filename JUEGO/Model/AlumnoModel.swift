//
//  AlumnoModel.swift
//  JUEGO
//
//  Created by Alumno on 26/05/23.
//

import Foundation
import FirebaseFirestore

class AlumnoModel : ObservableObject{
    @Published var listaAlumnos = [Alumno]()
    let _collection = Firestore.firestore().collection("alumnos")

    init()
    {
        Task {
            if let alumnos = await getAlumno(){
                DispatchQueue.main.async {
                    self.listaAlumnos = alumnos
                }
            }
        }
    }
    
    func addAlumno(alumno: Alumno, completion: @escaping (String) -> Void){
        let data = [
            "Nombre" : alumno.Nombre,
            "Apellido": alumno.Apellido,
            "Nivel": alumno.Nivel,
            "Pictogramas" : alumno.Pictogramas,
            "Tutores": alumno.Tutores
        ] as [String : Any]
        _collection.addDocument(data: data){ error in
            if let error = error {
                let errorMessage = error.localizedDescription
                print("Error creating user : \(errorMessage)")
                completion(error.localizedDescription)
            }
            else {
                completion("OK")
            }
        }
    }
    
    func getAlumno() async  -> [Alumno]?{
        do {
            let querySnapshot = try await _collection.getDocuments()
            var alumnos = [Alumno]()
            for document in querySnapshot.documents {
                let data = document.data()
                let nombre = data["Nombre"] as? String ?? "Sin nombre"
                let apellido = data["Apellido"] as? String ?? "Sin apellido"
                let nivel = data["Nivel"] as? Int ?? -1
                let tutores = data["Tutores"] as? [Tutor] ?? []
                let pictogramas = data["Pictogramas"] as? [Pictograma] ?? []
                let ident = document.documentID
                let alumno = Alumno(Id: ident, Nombre: nombre, Apellido: apellido, Nivel: nivel,  Tutores: tutores, Pictogramas: pictogramas)
                alumnos.append(alumno)
            }
            return alumnos
        }
        catch {
            print("Error al traer los datos")
        }
        return nil
    }
    
}
