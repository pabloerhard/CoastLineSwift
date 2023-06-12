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
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    let imagenes = ["Predeterminado", "Papá", "Mamá", "Herman@1", "Herman@2","Mascota1","Mascota2"]
    var geo: GeometryProxy
    @State private var shouldShowImagePicker = false
    @State private var isAddingPicto = false
    @State var image : UIImage?
    @State private var errorMessage = ""
    let repository = FirebaseService()
    @EnvironmentObject var userData: UserData

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
                if let imagen = image {
                        Section(header: Text("pictograma Elegido")) {
                            VStack{
                                Text(nombre)
                                    .font(.title)
                                    .padding(.bottom)
                                    .bold()
                                HStack{
                                    Spacer()
                                    Image(uiImage: imagen)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 300)
                                        .cornerRadius(10)
                                    Spacer()
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
                                .foregroundColor(Color(red:34/255,green:100/255,blue:164/255))
                                .frame(height: geo.size.height * 0.1)
                                .overlay(Text("seleccionar Imagen"))
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
                    /*repository.addImageToStorage(image: image!) { result in
                        switch result {
                        case .success(let urlString):
                            print("Image uploaded successfully. URL: \(urlString)")
                            // Handle success case
                        case .failure(let error):
                            errorMessage = "Error subiendo imagen a base de datos. Intente de nuevo"
                            showAlert = true
                            print("Error uploading image: \(error.localizedDescription)")
                            // Handle failure case
                        }
                    }*/
                    dismiss()
                }else{
                    showAlert = true
                }
                
            }) {
                Text("Añadir")
            })
            .navigationBarItems(leading: Button(action: {
                dismiss()
            }) {
                Text("Cancelar")
            })
            .navigationBarTitle("Añadir Pictograma")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .onAppear {
            for pictograma in userData.curAlumno.Pictogramas {
                usedNames.insert(pictograma.Nombre)
            }
        }
        .sheet(isPresented: $shouldShowImagePicker) {
            ImagePicker(image: $image)
        }
        
    }
    
    private func addPictograma() {
        let pictograma = PictogramaDto(Nombre: nombre, ImageUrl: "", Image: image!)
        pictogramas.append(pictograma)
        usedNames.insert(pictograma.Nombre)
    }
    
    private func isValidForm() -> Bool {
        return !nombre.isEmpty && (image != nil) && nombre != "Predeterminado"
    }
}
