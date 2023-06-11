//
//  AddPictogramaView.swift
//  JUEGO
//
//  Created by Alumno on 6/11/23.
//

import SwiftUI

struct AddPictogramaView: View {
    @Binding var pictogramas: [PictogramaDto]
    @Binding var usedNames:  Set<String>
    @State private var nombre = "Predeterminado"
    @State private var link = ""
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    let imagenes = ["Predeterminado", "Papa", "Mama", "Herman@1", "Herman@2","Mascota1","Mascota2"]
    var geo: GeometryProxy
    @State private var shouldShowImagePicker = false
    @State private var isAddingPicto = false
    @State var image : UIImage?

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
                    
                }
                Section(header: Text("Agregar pictograma")) {
                    HStack{
                        Spacer()
                        Button{
                            shouldShowImagePicker.toggle()
                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color(red:34/255,green:146/255,blue:164/255))
                                .frame(width:geo.size.width * 0.3,height: geo.size.height * 0.1)
                                .overlay(Text("Pictogramas"))
                                .font(Font.custom("HelveticaNeue-Thin", size: 24))
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
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
        .sheet(isPresented: $shouldShowImagePicker) {
            ImagePicker(image: $image)
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
