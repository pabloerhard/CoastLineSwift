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

struct SignInView: View {
    @State private var email = "admin@a.com"
    @State private var password = "123456"
    @StateObject private var vm = AuthenticationViewModel()
    @State private var alertLogIn = false
    @State private var errorLogIn = ""
    @State private var curTutor: Tutor?
    @EnvironmentObject var userData : UserData
    let repository = FirebaseService()
    var body: some View {
        if !userData.isLogIn{
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
                                                userData.isLogIn = true
                                                print("User signed in with uid: \(uid)")
                                                repository.getTutor(documentId: uid) { result in
                                                    switch result {
                                                    case .success(let tutor):
                                                        userData.curTutor = tutor
                                                        userData.curTutor.Id = uid
                                                        print("Tutor information: \(userData.curTutor)")
                                                        repository.getTutorAlumnos(tutorId: uid) { result in
                                                            switch result {
                                                            case .success(let alumnos):
                                                                userData.tutorAlumnos = alumnos
                                                                print("Todos alumnos del tutor extraidos correctamente")
                                                            case .failure(let error):
                                                                print("Error al obtener alumnos: \(error.localizedDescription)")
                                                            }
                                                        }
                                                        repository.getAlumnos() { result in
                                                            switch result {
                                                            case .success(let alumnos):
                                                                userData.allAlumnos = alumnos
                                                                print("Todos alumnos extraidos correctamente: \n \(alumnos)")
                                                            case .failure(let error):
                                                                print("Error al obtener alumnos: \(error.localizedDescription)")
                                                            }
                                                        }
                                                    case .failure(let error):
                                                        print("Error retriving tutor information: \(error)")
                                                        errorLogIn = "\(error.localizedDescription)"
                                                        alertLogIn = true
                                                    }
                                                }
                                            case .failure(let error):
                                                print("Error signing in: \(error)")
                                                errorLogIn = "\(error.localizedDescription)"
                                                alertLogIn = true
                                            }
                                        }
                                        
                                    }
                                    .frame(width: 200, height: 50)
                                    .foregroundColor(.white)
                                    .background(Color(red:34/255,green:146/255,blue:164/255))
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
                        Color(red:175/255,green:208/255,blue:213/255)
                        VStack{
                            Image(systemName: "sunrise.fill")
                                .resizable()
                                .frame(width:200,height:150)
                                .foregroundColor(.white)
                            Text("¡Bienvenidos a CoastLine!")
                                .foregroundColor(.white)
                                .font(Font.custom("HelveticaNeue-Thin", size: 30))
                        }
                        
                    }
                    .ignoresSafeArea(.all)
                }
            }
            .ignoresSafeArea()
            .background(Color(red:245/255,green:239/255,blue:237/255))
        }else{
            PerfilesView()
        }
    }
}



struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
