//
//  ContentView.swift
//  JUEGO
//
//  Created by Alumno on 26/04/23.
//

import SwiftUI

struct ContentView: View {
    var jugadores = [
    Jugador(id: 0, nombre: "Nico", puntos: 13, email: "ad@gma.com"), Jugador(id: 1, nombre: "David", puntos: 2, email: "goe@out.com"), Jugador(id: 3, nombre: "pepe", puntos: 532, email: "fko@iclo.com")
    ]
    
    // hola
    
    var body: some View {
        NavigationView{
            List(jugadores){
                jugador in
                NavigationLink{
                    ProfilesView(unJugador: jugador)
                } label: {
                    ProfilesView(unJugador: jugador)
                }
                
            }
            .navigationTitle("Jugadores")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
