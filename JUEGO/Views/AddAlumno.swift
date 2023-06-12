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
    
    @State private var isAddingPicto = false
    @State private var showAlert = false
    
    var tutor : String = Auth.auth().currentUser!.uid
    //var tutor : Tutor = Tutor(Id: curTutor , Nombre: <#T##String#>, Apellido: <#T##String#>)
    @State private var pictogramas = [PictogramaDto]()
    @State private var usedNames: Set<String> = []
    
    var body: some View {
        GeometryReader { geo in
            
            NavigationView {
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
                    Section(header: Text("Agregar pictograma (Puedes añadirlos despues)")) {
                        Button(action: {
                            isAddingPicto = true
                        }) {
                            Text("Agregar")
                        }
                        .padding()
                        .sheet(isPresented: $isAddingPicto, onDismiss: {
                            // Handle data from the sheet here if needed
                        }) {
                            AddPictogramaView(pictogramas: $pictogramas, usedNames: $usedNames)
                        }
                        
                        List {
                            ForEach(pictogramas, id: \.Nombre) { picto in
                                VStack{
                                    Text(picto.Nombre)
                                }
                            }
                            .onDelete{ indexSet in
                                for index in indexSet {
                                    let nombre = pictogramas[index].Nombre
                                    deletePictograma(at: indexSet, nombre: nombre)
                                }
                            }
                        }
                    }
                }
                .navigationBarItems(trailing: Button(action: {
                    if isValidForm() {
                        // Add the pictograma
                        dismiss()
                    } else {
                        showAlert = true
                    }
                }) {
                    Text("Add")
                })
                .navigationBarItems(leading: Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                })
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Alert"),
                        message: Text("All the fields are required"),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }
    private func deletePictograma(at offsets: IndexSet, nombre: String) {
        pictogramas.remove(atOffsets: offsets)
        usedNames.remove(nombre)
    }
    
    private func isValidForm() -> Bool {
        return false //!nombre.isEmpty && !link.isEmpty && nombre != "Predeterminado"
    }
}


struct AddAlumno_Previews: PreviewProvider {
    static var previews: some View {
        AddAlumno(alumnos: AlumnoModel())
    }
}

