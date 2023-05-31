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
    var body: some View {
        if !mostrarMenu{
            NavigationView {
                List {
                    ForEach(alumnos.listaAlumnos, id: \.self){
                        alumno in
                        VStack(alignment: .leading) {
                            Text(alumno.Nombre)
                                .font(.title3)
                                .bold()
                            Text(alumno.Apellido)
                        }
                        .padding()
                    }
                }
                .navigationTitle("Lista de alumnos")
                .toolbar {
                    Button{
                        mostrarAgregar = true
                     } label: {
                         Image(systemName: "plus")
                     }
                    .sheet(isPresented: $mostrarAgregar){
                        AgregarAlumno(alumnos: alumnos)
                    }
                    Button {
                        mostrarMenu = true
                    } label: {
                        Image(systemName: "checkerboard.rectangle")
                    }
                }
            }
        }
        else{
            MenuView()
        }
        
    }
}

struct PerfilesView_Previews: PreviewProvider {
    static var previews: some View {
        PerfilesView()
    }
}
