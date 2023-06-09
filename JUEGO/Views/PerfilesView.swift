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
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    //var alumnos : [Alumno]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        if !userData.mostrarMenu{
            NavigationView {
                VStack {
                    Section(header: Text("Tus Datos Personales:")){
                        Text("\(userData.curTutor.Nombre) \(userData.curTutor.Apellido)")
                    }
                    .padding()
                    List {
                        ForEach(Array(userData.otherAlumnos), id: \.self) { alumno in
                            Text(alumno.Nombre)
                                .swipeActions {
                                    Button("Añadir"){
                                        userData.tutorAlumnos.insert(alumno)
                                        userData.otherAlumnos.remove(alumno)
                                    }
                                    .tint(.green)
                                }
                        }
                    }

                }
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
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(Array(userData.tutorAlumnos), id: \.self) { alumno in
                            
                            ProfileView(alumno: alumno)
                        }
                    }
                    .padding(16)
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
        Button(action: {
            userData.curAlumno = alumno
            userData.mostrarMenu = true
        }) {
            VStack(alignment: .leading) {
                Text(alumno.Nombre)
                    .font(.title3)
                    .bold()
                Text(alumno.Apellido)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
        }
        .contextMenu {
            Button(action: {
                let filteredAlumnos = userData.tutorAlumnos.filter { tutorAlumno in
                    return tutorAlumno.Id != alumno.Id
                }
                userData.tutorAlumnos = filteredAlumnos
                userData.otherAlumnos.insert(alumno)
            }) {
                Label("Eliminar", systemImage: "trash")
            }
            /*Button(action: {
                // Perform action 2
            }) {
                Label("Action 2", systemImage: "heart")
            }
            // Add more buttons for additional actions as needed*/
        }
    }
}





struct PerfilesView_Previews: PreviewProvider {
    static var previews: some View {
        PerfilesView()
    }
}
