//
//  PerfilesView.swift
//  JUEGO
//
//  Created by Alumno on 26/05/23.
//

import SwiftUI
struct PerfilesView: View {
    @State private var mostrarAgregar =  false
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
                    Section(header: Text("Tus Datos Personales:")
                        .font(Font.custom("HelveticaNeue-Thin", size: 20))
                    ) {
                        Text("Nombre: \(userData.curTutor.Nombre)")
                            .font(Font.custom("HelveticaNeue-Thin", size: 30))
                        Text("Apellido: \(userData.curTutor.Apellido)")
                            .font(Font.custom("HelveticaNeue-Thin", size: 30))
                        Text("Cantidad de Alumnos: \(userData.tutorAlumnos.count)")
                    }
                    List {
                        ForEach(Array(userData.otherAlumnos), id: \.self) { alumno in
                            HStack {
                                Text(alumno.Nombre)
                                    .foregroundColor(.primary)
                                Button(action: {
                                    userData.tutorAlumnos.append(alumno)
                                    userData.otherAlumnos.removeAll{$0 == alumno}
                                }) {
                                    Image(systemName: "plus")
                                }
                                .foregroundColor(.green)
                            }
                        }
                    }
                }
                .background(Color(red: 175/255, green: 208/255, blue: 213/255))
                //.background(Color.clear)
                .navigationTitle("Hola, \(userData.curTutor.Nombre)!")
                
            
                .toolbar {
                    Button {
                        mostrarAgregar = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $mostrarAgregar, onDismiss: {
                        // Handle data from the sheet here if needed
                    }) {
                        //AddAlumno(alumnos: alumnos)
                    }
                }
                ScrollView {
                    Text("Lista de los Alumnos actuales de \(userData.curTutor.Nombre)")
                        .font(Font.custom("HelveticaNeue-Thin", size: 50))
                        
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(Array(userData.tutorAlumnos), id: \.self) { alumno in
                            
                            ProfileView(alumno: alumno)
                        }
                    }
                    .background(Color.clear)
                    .padding(16)
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
        }
        else{
            MenuView()
        }
    }
    
}

struct ProfileView: View {
    let alumno: Alumno
    @EnvironmentObject var userData: UserData
    
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
                userData.tutorAlumnos = filteredAlumnos
                userData.otherAlumnos.append(alumno)
            }) {
                Label("Quitar de mi lista", systemImage: "trash")
            }
        }
    }
}





struct PerfilesView_Previews: PreviewProvider {
    static var previews: some View {
        PerfilesView()
    }
}
