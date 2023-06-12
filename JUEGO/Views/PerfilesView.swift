//
//  PerfilesView.swift
//  JUEGO
//
//  Created by Alumno on 26/05/23.
//

import SwiftUI
struct PerfilesView: View {
    @State private var mostrarAgregar =  false
    @State private var searchText = ""
    @EnvironmentObject var userData : UserData
    let columns: [GridItem] = [
        GridItem(spacing: 16),
        GridItem(spacing: 16),
        GridItem(spacing: 16)
    ]
    //var alumnos : [Alumno]
    let repository = FirebaseService()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        if !userData.mostrarMenu{
            NavigationView {
                VStack(spacing: 0) {
                    Text("¡Hola, \(userData.curTutor.Nombre)!")
                        .font(Font.custom("HelveticaNeue-Thin", size: 35))
                        .bold()
                        .padding()
                    //                    Section(header: Text("Tus Datos Personales:")
                    //                        .font(Font.custom("HelveticaNeue-Thin", size: 30))
                    //                    ) {
                    //                        Text("Nombre: \(userData.curTutor.Nombre)")
                    //                            .font(Font.custom("HelveticaNeue-Thin", size: 20))
                    //                        Text("Apellido: \(userData.curTutor.Apellido)")
                    //                            .font(Font.custom("HelveticaNeue-Thin", size: 20))
                    Text("Mi lista de alumnos: \(userData.tutorAlumnos.count)")
                    //                    }
                    //                    Spacer()
                    HStack {
                        TextField("Buscar alumnos", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 200)
                        
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    ZStack {
                        Color(red: 245/255, green: 239/255, blue: 237/255)
                            .ignoresSafeArea()
                        
                        ScrollView {
                            if searchText == "" {
                                ForEach(Array(userData.otherAlumnos), id: \.self) { alumno in
                                    var mutableAlumno = alumno
                                    HStack {
                                        Spacer()
                                        Text(mutableAlumno.Nombre)
                                            .foregroundColor(.primary)
                                            .padding(.leading, 10)
                                        Text(mutableAlumno.Apellido)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Button(action: {
                                            userData.tutorAlumnos.append(mutableAlumno)
                                            userData.otherAlumnos.removeAll{$0 == mutableAlumno}
                                            mutableAlumno.Tutores.append(userData.curTutor.Id)
                                            Task {
                                                do {
                                                    let updatedAlumno = try await repository.updateAlumno(alumno: mutableAlumno)
                                                    mutableAlumno = updatedAlumno
                                                    print(mutableAlumno)
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
                                            }
                                        }) {
                                            Image(systemName: "plus")
                                                .padding(.trailing, 10)
                                        }
                                        .foregroundColor(.green)
                                    }
                                    .padding()
                                }
                            } else {
                                let filteredAlumnos = userData.otherAlumnos.filter { alumno in
                                    return alumno.Nombre.lowercased().contains(searchText.lowercased()) || "\(alumno.Nombre.lowercased() + " " + alumno.Apellido.lowercased())".contains(searchText.lowercased())
                                }
                                ForEach(Array(filteredAlumnos), id: \.self) { alumno in
                                    var mutableAlumno = alumno
                                    HStack {
                                        Spacer()
                                        Text(mutableAlumno.Nombre)
                                            .foregroundColor(.primary)
                                            .padding(.leading, 10)
                                        Text(mutableAlumno.Apellido)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Button(action: {
                                            userData.tutorAlumnos.append(mutableAlumno)
                                            userData.otherAlumnos.removeAll{$0 == mutableAlumno}
                                            mutableAlumno.Tutores.append(userData.curTutor.Id)
                                            Task {
                                                do {
                                                    let updatedAlumno = try await repository.updateAlumno(alumno: mutableAlumno)
                                                    mutableAlumno = updatedAlumno
                                                    print(mutableAlumno)
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
                                            }
                                            
                                        }) {
                                            Image(systemName: "plus")
                                                .padding(.trailing, 10)
                                        }
                                        .foregroundColor(.green)
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(Color(red: 245/255, green: 239/255, blue: 237/255))
                    .ignoresSafeArea()
                }
                .background(Color(red: 175/255, green: 208/255, blue: 213/255))
                .toolbar {
                    Button {
                        mostrarAgregar = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $mostrarAgregar) {
                        AddAlumnoView()
                    }
                }
                .background(Color(red:34/255,green:146/255,blue:164/255))
                ScrollView {
                    Text("Lista de los alumnos de \(userData.curTutor.Nombre)")
                        .font(Font.custom("HelveticaNeue-Thin", size: 50))
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(userData.tutorAlumnos.indices, id: \.self) { index in
                            ProfileView(alumno: $userData.tutorAlumnos[index])
                        }

                    }
                    .background(Color.clear)
                    .padding(16)
                }
                .refreshable {
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
                }
                .background(Color(red:245/255,green:239/255,blue:237/255))
            }
            .onAppear{
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
            }
            .background(Color(red: 175/255, green: 208/255, blue: 213/255))
        } else{
            MenuView()
        }
    }
    
}

struct ProfileView: View {
    @Binding var alumno: Alumno
    @EnvironmentObject var userData: UserData
    @State private var edit = false
    let repository = FirebaseService()
    var body: some View {
        Button {
            userData.curAlumno = alumno
            userData.mostrarMenu = true
        }label: {
            VStack(alignment: .center) {
                Text(alumno.Nombre)
                    .font(Font.custom("HelveticaNeue-Thin", size: 24))
                    .foregroundColor(.white)
                
                Text(alumno.Apellido)
                    .font(Font.custom("HelveticaNeue-Thin", size: 24))
                    .foregroundColor(.white)
                
                Text("Nivel: \(alumno.Nivel)")
                    .font(Font.custom("HelveticaNeue-Thin", size: 20))
                    .foregroundColor(.white)
                
            }
            .padding()
            .frame(minWidth: 50,maxWidth: .infinity,minHeight:30,maxHeight:.infinity)
            .background(Color(red:34/255,green:146/255,blue:164/255))
            .cornerRadius(10)
            .shadow(radius: 2)
        }
        .contextMenu {
            Button(action: {
                let filteredAlumnos = userData.tutorAlumnos.filter { tutorAlumno in
                    return tutorAlumno.Id != alumno.Id
                }
                let filteredTutors = alumno.Tutores.filter { tutor in
                    return tutor != userData.curTutor.Id
                }
                alumno.Tutores = filteredTutors
                Task {
                    do {
                        let updatedAlumno = try await repository.updateAlumno(alumno: alumno)
                        print(updatedAlumno)
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
                }
            }) {
                Label("Quitar de mi lista", systemImage: "trash")
            }
            Button(action: {
                userData.curAlumno = alumno
                edit = true
            }) {
                Label("Editar", systemImage: "pencil")
            }
        }
        .sheet(isPresented: $edit){
            EditAlumnoView()
        }
    }
}

struct NavigationTitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("HelveticaNeue-Thin", size: 35))
            .foregroundColor(.black)
            .fontWeight(.bold)
    }
}




struct PerfilesView_Previews: PreviewProvider {
    static var previews: some View {
        PerfilesView()
    }
}
