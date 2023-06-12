//
//  AlumnoModel.swift
//  JUEGO
//
//  Created by Alumno on 22/05/23.
//

import Foundation

struct Alumno: Hashable, Codable {
    var Id: String!
    var Nombre: String
    var Apellido: String
    var Nivel: Int
    var Tutores: [String]
    var Pictogramas: [Pictograma]
    
    static func == (lhs: Alumno, rhs: Alumno) -> Bool {
        return lhs.Id == rhs.Id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(Id)
    }
}
