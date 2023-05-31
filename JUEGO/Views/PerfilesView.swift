//
//  PerfilesView.swift
//  JUEGO
//
//  Created by Alumno on 26/05/23.
//

import SwiftUI

struct PerfilesView: View {
    //@State private var mostrarAgregar =  false
    //@StateObject var equipos = ModeloEquipos()
    var body: some View {
        VStack{
            Text("Lista de Perfiles")
        }
        /*NavigationView {
            List {
                ForEach(equipos.listaEquipos, id: \.self){
                    equipo in
                    VStack(alignment: .leading) {
                        Text(equipo.nombre)
                            .font(.title3)
                            .bold()
                        Text(equipo.ciudad)
                    }
                    .padding()
                }
            }
            .navigationTitle("Lista de Equipos")
            .toolbar {
                Button {
                    mostrarAgregar = true
                } label: {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: $mostrarAgregar){
                    AgregarEquipo(equipos: equipos)
                }

            }
        }*/
        
    }
}

struct PerfilesView_Previews: PreviewProvider {
    static var previews: some View {
        PerfilesView()
    }
}
