//
//  AddAlumno.swift
//  JUEGO
//
//  Created by Alumno on 31/05/23.
//

import SwiftUI
import Firebase

struct AddAlumnoView: View {
    @EnvironmentObject var userData: UserData
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionSheet = false
    @State private var shouldShowImagePicker = false
    @State private var isAddingPicto = false
    @State var image : UIImage?
    @State private var pictogramas = [PictogramaDto]()
    @State private var usedNames: Set<String> = []
    @State private var isWatchingPictograma = false
    @Environment(\.dismiss) var dismiss
    @Environment(\.dismiss) var dismiss1
    @State private var showAlert = false
    @State private var tempPictogramas = [Pictograma]()
    let repository = FirebaseService()
    @State private var errorMessage = ""
    
    
    @State private var nombre : String = ""
    @State private var apellido : String = ""
    @State private var nivel : Int = 1

    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack{
                    Form {
                        Text("Añadir Alumno")
                            .font(.largeTitle)
                            .bold()
                        Section(header: Text("Datos Personales")) {
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
                        
                        Section(header: Text("Informacion General")) {
                            LabeledContent {
                                Picker("", selection: $nivel) {
                                    ForEach(1...6, id: \.self) { nivel in
                                        Text("\(nivel)")
                                    }
                                }
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
                        Section(header: Text("Pictogramas")) {
                            if pictogramas.isEmpty {
                                Text("Actualmente \(nombre.count > 4 ? nombre : "el Alumno") No Tiene Pictogramas")
                            } else{
                                ForEach(pictogramas, id: \.Nombre) { picto in
                                    VStack{
                                        if let imagen = picto.Image {
                                            Button {
                                                isWatchingPictograma.toggle()
                                            } label: {
                                                HStack {
                                                    Text(picto.Nombre)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .foregroundColor(.black)
                                                    Spacer()
                                                    Text("Pulsa para ver imagen")
                                                        .font(.caption2)
                                                        .foregroundColor(.gray)
                                                    Image(uiImage: imagen)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 50, height: 50)
                                                        .cornerRadius(10)
                                                }
                                            }
                                            .sheet(isPresented: $isWatchingPictograma) {
                                                VStack{
                                                    Text(picto.Nombre)
                                                        .font(.title2)
                                                        .bold()
                                                    HStack{
                                                        Spacer()
                                                        Image(uiImage: imagen)
                                                            .resizable()
                                                            .scaledToFit()
                                                            .cornerRadius(10)
                                                        Spacer()
                                                    }
                                                    Text("Desliza hacia abajo para cerrar vista")
                                                        .font(.caption2)
                                                        .foregroundColor(.gray)
                                                }
                                                .padding()
                                            }
                                        }
                                    }
                                }
                                .onDelete { indices in
                                    pictogramas.remove(atOffsets: indices)
                                }
                            }
                        }
                        Section(header: Text("Agregar pictograma")) {
                            HStack {
                                Spacer()
                                Button {
                                    isAddingPicto.toggle()
                                } label: {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color(red:34/255,green:100/255,blue:164/255))
                                        .frame(height: geo.size.height * 0.1)
                                        .overlay(Text("Formulario de Pictogramas"))
                                        .font(Font.custom("HelveticaNeue-Thin", size: 24))
                                        .foregroundColor(.white)
                                }
                                Spacer()
                            }
                        }
                        
                    }
                    .navigationBarItems(trailing:
                                            Button(action: {
                        if isValidForm() {
                            var alumno = Alumno(Nombre: nombre, Apellido: apellido, Nivel: nivel, Tutores: [userData.curTutor.Id], Pictogramas: [])
                            var pictos: [Pictograma] = []
                            let uploadGroup = DispatchGroup()
                            for pictograma in pictogramas {
                                uploadGroup.enter() // Notify the group that a task has started
                                repository.addImageToStorage(image: pictograma.Image!) { result in
                                    switch result {
                                    case .success(let urlString):
                                        print("Image uploaded successfully. URL: \(urlString)")
                                        pictos.append(Pictograma(Nombre: pictograma.Nombre, Image: urlString))
                                        // Handle success case
                                    case .failure(let error):
                                        errorMessage = "Error subiendo imagen a base de datos. Intente de nuevo"
                                        showAlert = true
                                        print("Error uploading image: \(error.localizedDescription)")
                                        // Handle failure case
                                    }
                                    uploadGroup.leave() // Notify the group that a task has completed
                                }
                            }
                            
                            // Wait for all image uploads to complete
                            uploadGroup.notify(queue: .main) {
                                print(pictos)
                                alumno.Pictogramas = pictos
                                Task {
                                    do {
                                        let insertedAlumno = try await repository.insertAlumno(alumno: alumno)
                                        print(insertedAlumno)
                                        Task {
                                            do {
                                                let alumnos = try await repository.getAlumnos()
                                                DispatchQueue.main.async {
                                                    userData.allAlumnos = alumnos
                                                }
                                                let filteredTutorAlumnos = alumnos.filter { alumno in
                                                    return alumno.Tutores.contains(userData.curTutor.Id)
                                                }
                                                userData.tutorAlumnos = filteredTutorAlumnos
                                                print("Alumnos de tutor extraidos correctamente \n")
                                                print("\(userData.tutorAlumnos) \n ")
                                                let filteredOtherAlumnos = alumnos.filter { alumno in
                                                    return !alumno.Tutores.contains(userData.curTutor.Id)
                                                }
                                                userData.otherAlumnos = filteredOtherAlumnos
                                                print("Resto de alumnos \n")
                                                print("\(userData.otherAlumnos) \n ")
                                            } catch {
                                                print("Error al obtener alumnos: \(error.localizedDescription)")
                                            }
                                        }
                                    } catch {
                                        // An error occurred while updating the alumno
                                        print("Error updating alumno: \(error)")
                                    }
                                    dismiss()
                                }
                            }
                            
                        } else {
                            showAlert = true
                        }
                    }) {
                        Text("Añadir")
                    }
                    )
                    
                    .navigationBarItems(leading: Button(action: {
                        dismiss()
                    }) {
                        Text("Cancelar")
                    })
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Error"),
                            message: Text(errorMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
            }
            .onAppear{
                userData.tempCurAlumnoInfo = userData.curAlumno
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $shouldShowImagePicker) {
            ImagePicker(image: $image)
        }
        .sheet(isPresented: $isAddingPicto){
            AddPictogramaView(pictogramas: $pictogramas, usedNames: $usedNames)
        }
        
    }
    private func deletePictograma(at offsets: IndexSet, nombre: String) {
        pictogramas.remove(atOffsets: offsets)
        usedNames.remove(nombre)
    }
    
    private func isValidForm() -> Bool {
        return  !nombre.isEmpty && !apellido.isEmpty
    }
    
}
