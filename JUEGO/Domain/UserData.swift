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
    @Published var curAlumno: Alumno = Alumno(Nombre: "", Apellido: "", Nivel: 0, Tutores: [], Pictogramas: [])
    @Published var tutorAlumnos = [Alumno]()
    @Published var otherAlumnos = [Alumno]()
    @Published var allAlumnos = [Alumno]()
    @Published var tempCurAlumnoInfo : Alumno = Alumno(Nombre: "", Apellido: "", Nivel: 0, Tutores: [], Pictogramas: [])
    @Published var isLogIn : Bool = false
    @Published var mostrarMenu : Bool = false
    @Published var allAlumnosId = Set<String>()
}
