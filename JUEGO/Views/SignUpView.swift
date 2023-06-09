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
    @State private var apellido=""
    @State private var email=""
    @State private var password=""
    @State private var alertLogIn = false
    @State private var errorLogIn = ""
    @State private var isLogIn=false
    @State private var showRegisterSuccess=false
    let repository = FirebaseService()
    @EnvironmentObject var userData : UserData
    
    var body: some View {
        if !isLogIn{
            GeometryReader{geo in
                VStack{
                    VStack(alignment: .center) {
                        Text("Bienvenido")
                            .font(Font.custom("HelveticaNeue-Thin", size: 48))
                        
                        HStack {
                            TextField("Inserta Nombre", text: $nombre)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                                .border(Color.black)
                                .keyboardType(.default)
                                .frame(width: geo.size.width * 0.4)
                            
                            TextField("Inserta Apellido", text: $apellido)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                                .border(Color.black)
                                .keyboardType(.default)
                                .frame(width: geo.size.width * 0.4)
                        }
                        
                        HStack {
                            TextField("Inserta Email", text: $email)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                                .border(Color.black)
                                .keyboardType(.emailAddress)
                                .frame(width: geo.size.width * 0.4)
                            
                            SecureField("Inserta Contraseña", text: $password)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                                .border(Color.black)
                                .keyboardType(.default)
                                .frame(width: geo.size.width * 0.4)
                        }
                    }
                    .padding()
                    VStack {
                        Button(action: {
                            if !email.isEmpty && !password.isEmpty && !apellido.isEmpty && !nombre.isEmpty {
                                repository.register(email: email, password: password, nombre: nombre, apellido: apellido) { result in
                                    switch result {
                                    case .success(let uid):
                                        userData.isLogIn = true
                                        isLogIn = true
                                        showRegisterSuccess=true
                                        print("Tutor registered in with uid: \(uid)")
                                        let tut = Tutor(Id:uid, Nombre: nombre, Apellido: apellido)
                                        repository.insertTutor(tutor: tut)
                                        userData.curTutor = tut
                                    case .failure(let error):
                                        print("Error registering user in: \(error)")
                                        errorLogIn = "\(error.localizedDescription)"
                                        alertLogIn = true
                                    }
                                }
                            }else {
                                errorLogIn="Todos los campos son obligatorios"
                                alertLogIn=true
                            }
                            
                        }) {
                            Text("Crear Cuenta")
                                .font(Font.custom("HelveticaNeue-Thin", size: 24))
                                .foregroundColor(.white)
                                .frame(width: geo.size.width * 0.5, height: 50)
                                .background(Color.black)
                                .cornerRadius(10)
                                .shadow(color: .gray, radius: 4, x: 0, y: 2)
                        }
                        .padding(.vertical, 10)
                        .alert(isPresented: $alertLogIn) {
                            Alert(title: Text(errorLogIn))
                        }
                    }
                    .popover(isPresented: $showRegisterSuccess) {
                        VStack {
                            Text("Se ha registrado con exito")
                            Button("OK") {
                                showRegisterSuccess = false
                            }
                        }
                    }

                }
                
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .alignmentGuide(.leading) { _ in geo.size.height / 2 }
            }
        }else{
            PerfilesView()
        }
    }
}

struct signUpView_Previews: PreviewProvider {
    static var previews: some View {
        signUpView()
    }
}
