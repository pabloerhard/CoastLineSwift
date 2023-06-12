//
//  Pictograma.swift
//  JUEGO
//
//  Created by Alumno on 26/05/23.
//

import Foundation
import SwiftUI

struct Pictograma: Codable{
    var Nombre: String
    var Image: String
}

struct PictogramaDto {
    let Nombre: String
    let ImageUrl:  String
    let Image: UIImage?
}
