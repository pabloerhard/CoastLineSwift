//
//  Perfiles.swift
//  JUEGO
//
//  Created by Alumno on 26/04/23.
//

import Foundation
class Jugador: Identifiable{
    var id: Int = 0
    var nombre: String = ""
    var puntos: Int = 0
    var email: String = ""
    
    init(id: Int, nombre: String, puntos: Int, email: String) {
        self.id = id
        self.nombre = nombre
        self.puntos = puntos
        self.email = email
    }
}
