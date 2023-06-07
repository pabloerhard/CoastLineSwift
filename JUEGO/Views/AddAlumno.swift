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
                        AddPictoView(pictogramas: $pictogramas, usedNames: $usedNames)
                    }
                    
                    List {
                        ForEach(pictogramas) { picto in
                            VStack{
                                Text(picto.Nombre)
                                Text(picto.Url)
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
                    message: Text("This is the alert message."),
                    dismissButton: .default(Text("OK"))
                )
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

struct AddPictoView: View {
    @Binding var pictogramas: [PictogramaDto]
    @Binding var usedNames:  Set<String>
    @State private var nombre = "Predeterminado"
    @State private var link = ""
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    let imagenes = ["Predeterminado", "Papa", "Mama", "Herman@1", "Herman@2","Mascota1","Mascota2"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Añadir pictogramas")) {
                    Picker("Nombre", selection: $nombre) {
                        ForEach(imagenes, id: \.self) { imagen in
                            if !usedNames.contains(imagen){
                                Text(imagen)
                            }
                        }
                    }
                    TextField("Link de Imagen", text: $link)
                }
            }
            .navigationBarItems(trailing: Button(action: {
                if isValidForm(){
                    addPictograma()
                    dismiss()
                }else{
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
            .navigationBarTitle("Add Friends")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Alert"),
                    message: Text("This is the alert message."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    private func addPictograma() {
        let pictograma = PictogramaDto(Nombre: nombre, Url: link)
        pictogramas.append(pictograma)
        usedNames.insert(pictograma.Nombre)
    }
    
    private func isValidForm() -> Bool {
        return !nombre.isEmpty && !link.isEmpty && nombre != "Predeterminado"
    }
}

struct AddAlumno_Previews: PreviewProvider {
    static var previews: some View {
        AddAlumno(alumnos: AlumnoModel())
    }
}

