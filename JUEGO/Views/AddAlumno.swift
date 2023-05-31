//
//  AddAlumno.swift
//  JUEGO
//
//  Created by Alumno on 31/05/23.
//

import SwiftUI
import Firebase

struct AddAlumno: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var alumnos : AlumnoModel
    @State private var nombre : String = ""
    @State private var apellido : String = ""
    var nivel : Int = 1
    var tutor : String = Auth.auth().currentUser!.uid
    var pictogramas : Pictograma = Pictograma(Nombre: "", Url: "")
    
    var body: some View {
        Form{
            Text("Agrega alumno")
                .font(.largeTitle)
                .bold()
                .padding(.bottom)
            Section(header: Text("Datos personales")){
                TextField("Nombre", text: $nombre)
                    .padding()
            }
            TextField("Apellido", text: $apellido)
                .padding()
            TextField("Nivel", text: .constant("\(nivel)"))
                .padding()
                .disabled(true)
            TextField("Tutor", text: .constant(tutor))
                .padding()
                .disabled(true)
            Button("Agregar"){
                let alumno = Alumno(Nombre: nombre, Apellido: apellido, Nivel: nivel, Tutores: [tutor])
                alumnos.addAlumno(alumno: alumno) { error in
                    if error != "OK" {
                        print(error)
                    }
                    else{
                        Task{
                            if let alumnos = await alumnos.getAlumno(){
                                DispatchQueue.main.async {
                                    self.alumnos.listaAlumnos = alumnos
                                    dismiss()
                                }
                            }
                        }
                    }
                }
            }
            font(.title)
        }
    }
}


struct AddAlumno_Previews: PreviewProvider {
    static var previews: some View {
        AddAlumno(alumnos: AlumnoModel())
    }
}
