//
//  signUpView.swift
//  JUEGO
//
//  Created by Alejandro on 08/05/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
struct signUpView: View {
    @State private var nombre=""
    @State private var email=""
    @State private var password=""
    
    var body: some View {
        GeometryReader{geo in
            VStack{
                VStack(alignment: .center){
                    Text("Bienvenido")
                        .font(Font.custom("HelveticaNeue-Thin", size: 48))
                    
                    HStack{
                        TextField("Inserta Email", text: $email)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .border(Color.black)
                            .keyboardType(.emailAddress)
                            .frame(width: geo.size.width * 0.4)
                        TextField("Inserta Nombre", text: $nombre)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .border(Color.black)
                            .keyboardType(.default)
                            .frame(width: geo.size.width * 0.4)
                    }
                    TextField("Inserta Contraseña", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .border(Color.black)
                        .keyboardType(.default)
                        .frame(width: geo.size.width * 0.82)
                }
                
                VStack{
                    Button("Crear Cuenta") {
                        register()
                    }
                    .font(Font.custom("HelveticaNeue-Thin", size: 24))
                    .foregroundColor(.black)
                    .frame(width:geo.size.width*0.5)
                    .padding(.vertical,10)
                    .background(.gray)
                    .cornerRadius(10)
                }
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .alignmentGuide(.leading) { _ in geo.size.height / 2 }
        }
    }
    
    func register(){
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("User registered successfully!")
            }
        }
        }

    
    
}


struct signUpView_Previews: PreviewProvider {
    static var previews: some View {
        signUpView()
    }
}
