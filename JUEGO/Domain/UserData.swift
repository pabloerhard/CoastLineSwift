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
    @Published var tutorAlumnos = Set<Alumno>()
    @Published var otherAlumnos = Set<Alumno>()
    @Published var allAlumnos = Set<Alumno>()
    @Published var isLogIn : Bool = false
    @Published var mostrarMenu : Bool = false
    @Published var allAlumnosId = Set<String>()
}
