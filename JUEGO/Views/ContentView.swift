//
//  ContentView.swift
//  JUEGO
//
//  Created by Alumno on 26/04/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var email = ""
    @State private var password = ""
    var body: some View {
        
        GeometryReader {geo in
            VStack(alignment: .center){
                Text("Log In")
                    .font(Font.custom("HelveticaNeue-Thin", size: 48))
                TextField("Inserta Email", text: $email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .border(Color.black)
                    .keyboardType(.emailAddress)
                    .frame(width: geo.size.width * 0.5)
                TextField("Inserta Usuario", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .border(Color.black)
                    .keyboardType(.default)
                    .frame(width: geo.size.width * 0.5)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .alignmentGuide(.leading) { _ in geo.size.height / 2 }
        }

        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
