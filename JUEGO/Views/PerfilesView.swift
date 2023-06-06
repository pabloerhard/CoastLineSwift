//
//  PerfilesView.swift
//  JUEGO
//
//  Created by Alumno on 26/05/23.
//

import SwiftUI
struct PerfilesView: View {
    @State private var mostrarAgregar =  false
    @State private var mostrarMenu =  false
    @StateObject var alumnos = AlumnoModel()
    @EnvironmentObject var userData : UserData
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    var body: some View {
        if !mostrarMenu{
            NavigationView {
                VStack {
                    Section(header: Text("Tus Datos Personales:")){
                        Text("\(userData.curTutor.Nombre) \(userData.curTutor.Apellido)")
                    }
                    .padding()
//                    Section(header: Text("Tus Datos Personales:")){
//                        Text("\(userData.curTutor.Nombre) \(userData.curTutor.Apellido)")
//                    }
                }
                .navigationTitle("Hola, \(userData.curTutor.Nombre)!")
                .toolbar {
                    Button {
                        mostrarAgregar = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $mostrarAgregar) {
                        AddAlumno(alumnos: alumnos)
                    }
                    Button {
                        mostrarMenu = true
                    } label: {
                        Image(systemName: "checkerboard.rectangle")
                    }
                }
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(alumnos.listaAlumnos, id: \.self) { alumno in
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
    
    var body: some View {
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
}


struct PerfilesView_Previews: PreviewProvider {
    static var previews: some View {
        PerfilesView()
    }
}
