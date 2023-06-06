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
    @EnvironmentObject var userData : UserData
    @State private var nombre : String = ""
    @State private var apellido : String = ""
    var nivel : Int = 1
    @State private var agregarPictograma = false
    @State private var pictogramaFields: [PictogramaField] = []
    
    var tutor : String = Auth.auth().currentUser!.uid
    //var tutor : Tutor = Tutor(Id: curTutor , Nombre: <#T##String#>, Apellido: <#T##String#>)
    var pictogramas : Pictograma = Pictograma(Nombre: "", Url: "")
    
    var body: some View {
        Form{
            Text("Agrega alumno")
                .font(.largeTitle)
                .bold()
                .padding()
            Section(header: Text("Datos Personales")){
                LabeledContent {
                    TextField("Nombre", text: $nombre)
                } label: {
                    Text("Nombre: ")
                }
                LabeledContent {
                    TextField("Apellido", text: $apellido)
                } label: {
                    Text("Apellido: ")
                }
            }
            Section(header: Text("Informacion Predeterminada")){
                LabeledContent {
                    TextField("Nivel", text: .constant("\(nivel)"))
                        .foregroundColor(.gray)
                        .disabled(true)
                } label: {
                    Text("Nivel Inicial: ")
                }
                
                LabeledContent {
                    TextField("Tutor", text: .constant("\(userData.curTutor.Nombre) \(userData.curTutor.Apellido) - (Tutor Actual)"))
                        .foregroundColor(.gray)
                        .disabled(true)
                } label: {
                    Text("Tutor de \(nombre.count > 4 ? nombre : "Alumno"): ")
                }
            }
            Section(header: Text("Agregar pictograma")) {
                Button(action: {
                    agregarPictograma.toggle()
                    
                    if agregarPictograma {
                        pictogramaFields.append(PictogramaField())
                    } else {
                        pictogramaFields.removeAll()
                    }
                }) {
                    Text(agregarPictograma ? "Cerrar" : "Agregar")
                }
                
                if agregarPictograma {
                    ForEach(pictogramaFields.indices, id: \.self) { index in
                        PictogramaView(pictogramaFields: $pictogramaFields, index: index)
                    }
                }
            }
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

struct PictogramaField: Identifiable {
    let id = UUID()
    var nombre: String = ""
    var link: String = ""
}

struct PictogramaView: View {
    @Binding var pictogramaFields: [PictogramaField]
    let index: Int
    
    var body: some View {
        VStack {
            TextField("Nombre", text: $pictogramaFields[index].nombre)
            
            TextField("Link", text: $pictogramaFields[index].link)
            
            Button(action: {
                pictogramaFields.remove(at: index)
            }) {
                Text("Remove")
            }
        }
    }
}


struct AddAlumno_Previews: PreviewProvider {
    static var previews: some View {
        AddAlumno(alumnos: AlumnoModel())
    }
}
