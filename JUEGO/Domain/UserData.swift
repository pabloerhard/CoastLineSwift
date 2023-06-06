//
//  UserData.swift
//  JUEGO
//
//  Created by Alumno on 6/5/23.
//

import Foundation
import SwiftUI

class UserData: ObservableObject {
    @Published var curTutor: Tutor = Tutor(Nombre: "", Apellido: "")
    @Published var curAlumno: Alumno = Alumno(Nombre: "", Apellido: "", Nivel: 0, Tutores: [""])
}
