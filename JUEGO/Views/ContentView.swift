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
    var body: some View {
        
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
                        
                        TextField("Inserta Usuario", text: $password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .border(Color.black)
                            .keyboardType(.default)
                            .frame(width: geo.size.width * 0.5)
                        
                        HStack{
                            Button("Log In") {
                                //Log In
                            }
                            .frame(width: 200, height: 50)
                            .foregroundColor(.white)
                            .background(.black)
                            .cornerRadius(10)
                            .shadow(color:.gray,radius:4,x:0,y:2)
                            
                            
                            
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

        
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
