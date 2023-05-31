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
                            Register(email: email, password: password, nombre: nombre, apellido: apellido) { error in
                                if let errorMessage = error {
                                    errorLogIn = errorMessage
                                    alertLogIn = true
                                } else {
                                    isLogIn = true
                                }
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
                }
                
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .alignmentGuide(.leading) { _ in geo.size.height / 2 }
            }
        }else{
            MenuView()
        }
    }
}


func Register(email: String, password: String, nombre: String, apellido: String, completion: @escaping (String?) -> Void) {
    Auth.auth().createUser(withEmail: email, password: password) { result, error in
        if let error = error {
            let errorMessage = error.localizedDescription
            print("Error creating user : \(errorMessage)")
            completion(errorMessage)
            return
        }
        print("User registered successfully!")
        guard let user = result?.user else {
            return
        }
        let userId = user.uid
        let newTutor = Tutor(Id: userId, Nombre: nombre, Apellido: apellido)
        InsertUser(tutor: newTutor)
        completion(nil)
    }
}
            
func InsertUser(tutor: Tutor){
    let tutorRef = Firestore.firestore().collection("tutores")
    let data = [
        "Nombre": tutor.Nombre,
        "Apellido": tutor.Apellido
    ]
    tutorRef.document(tutor.Id).setData(data) { error in
        if let error = error {
            print("Error inserting document: \(error.localizedDescription)")
        } else {
            print("Document inserted with ID: \(tutor.Id ?? "error with id")")
        }
    }
}


struct signUpView_Previews: PreviewProvider {
    static var previews: some View {
        signUpView()
    }
}
