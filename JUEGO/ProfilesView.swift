//
//  ProfilesView.swift
//  JUEGO
//
//  Created by Alumno on 26/04/23.
//

import SwiftUI

struct ProfilesView: View {
    var unJugador : Jugador
    var body: some View {
        VStack{
            Image(systemName: "person.crop.circle")
            Text(unJugador.nombre)
            Text(unJugador.email)
            Text("\(unJugador.puntos)")
                
        }
    }
}

struct ProfilesView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilesView(unJugador: Jugador(id: 5, nombre: "Ganzo", puntos: 432, email: "ga.gmail.com"))
    }
}
