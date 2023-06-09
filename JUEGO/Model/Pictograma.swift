//
//  Pictograma.swift
//  JUEGO
//
//  Created by Alumno on 26/05/23.
//

import Foundation

struct Pictograma: Codable{
    var Nombre: String
    var Url: String
}

struct PictogramaDto: Identifiable {
    let id = UUID()
    let Nombre: String
    let Url: String
}
