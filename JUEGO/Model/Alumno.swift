//
//  AlumnoModel.swift
//  JUEGO
//
//  Created by Alumno on 22/05/23.
//

import Foundation

struct Alumno: Codable{
    var Id: String!
    var Nombre: String
    var Apellido: String
    var Nivel: Int
    var Tutores: [String] = []
    var Pictogramas: [Pictograma] = []
}
