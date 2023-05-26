//
//  AlumnoModel.swift
//  JUEGO
//
//  Created by Alumno on 22/05/23.
//

import Foundation

struct Alumno: Codable{
    var id: String
    var nombre: String
    var apellido: String
    var tutores: [String] = []
}
