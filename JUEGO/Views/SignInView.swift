//
//  ContentView.swift
//  JUEGO
//
//  Created by Alumno on 26/04/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import GoogleSignInSwift

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @StateObject private var vm = AuthenticationViewModel()
    @State private var alertLogIn = false
    @State private var errorLogIn = ""
    @State private var isLogIn = false
    @State var curTutor: Tutor?
    let repository = FirebaseService()
    var body: some View {
        
        if !isLogIn{
            HStack(spacing:0){
                
                GeometryReader {geo in
                    VStack {
                        NavigationView {
                            VStack(alignment: .center){
                                Spacer()
                                Text("Log In")
                                    .font(Font.custom("HelveticaNeue-Thin", size: 48))
                                
                                NavigationLink(destination:signUpView()){
                                    Text("Crear Cuenta")
                                }
                                .padding()
                                
                                TextField("Inserta Email", text: $email)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(15)
                                    .border(Color.black)
                                    .keyboardType(.emailAddress)
                                    .frame(width: geo.size.width * 0.5)
                                
                                TextField("Inserta Contraseña", text: $password)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(15)
                                    .border(Color.black)
                                    .keyboardType(.default)
                                    .frame(width: geo.size.width * 0.5)
                                
                                HStack{
                                    Button("Log In") {
                                        repository.signIn(email: email, password: password) { result in
                                            switch result {
                                            case .success(let uid):
                                                isLogIn = true
                                                print("User signed in with uid: \(uid)")
                                            case .failure(let error):
                                                print("Error signing in: \(error)")
                                                errorLogIn = "\(error.localizedDescription)"
                                                alertLogIn = true
                                            }
                                        }
                                        
                                    }
                                    .frame(width: 200, height: 50)
                                    .foregroundColor(.white)
                                    .background(.black)
                                    .cornerRadius(10)
                                    .shadow(color:.gray,radius:4,x:0,y:2)
                                    .alert(isPresented: $alertLogIn) {
                                        Alert(title:Text(errorLogIn))
                                    }
                                    
                                    Text("OR")
                                        .padding()
                                        .font(Font.custom("HelveticaNeue-Thin", size: 24))
                                    
                                    GoogleSignInButton {
                                        vm.signInWithGoogle()
                                    }
                                    .frame(width: 200, height: 50)
                                    .cornerRadius(15)
                                    
                                    
                                }
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .alignmentGuide(.leading) { _ in geo.size.height / 2 }
                            
                        }
                        .navigationViewStyle(StackNavigationViewStyle())
                    }
                }
                
                VStack {
                    ZStack{
                        Color.black
                        VStack{
                            Text("¡Bienvenidos a CoastLine!")
                                .foregroundColor(.white)
                                .font(Font.custom("HelveticaNeue-Thin", size: 30))
                        }
                        
                    }
                    .ignoresSafeArea(.all)
                }
            }
        }else{
            PerfilesView()
        }
        
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
