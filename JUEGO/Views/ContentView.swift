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
                                logIn(email: email, password: password) { error in
                                    if let errorMessage = error {
                                        errorLogIn = errorMessage
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
    }
}

func logIn(email: String, password: String, completion: @escaping (String?) -> Void) {
    Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
        if let error = error {
            let errorMessage = error.localizedDescription
            print("Error signing in:", errorMessage)
            completion(errorMessage)
        } else {
            print("User signed in successfully!")
            if let currentUser = Auth.auth().currentUser {
                getTutorInformation(user: currentUser)
                getChildrenInformation(user: currentUser)
            }
            completion(nil)
        }
    }
}


let db = Firestore.firestore()
func getTutorInformation(user: User){
    let userRef = db.collection("tutores").document(user.uid)
    userRef.getDocument { (documentSnapshot, error) in
        if let error = error {
            print("Error fetching user document:", error)
            return
        }
        
        guard let userData = documentSnapshot?.data() else {
            print("User document not found")
            return
        }
        
        // Access the user data here
        print("User data:", userData)
    }
}

func getChildrenInformation(user: User){
    let childrenRef = db.collection("alumnos")
    let query = childrenRef.whereField("Tutores", arrayContains: user.uid)
    query.getDocuments { (querySnapshot, error) in
        if let error = error {
            print("Error fetching children documents:", error)
            return
        }
        
        // Process the query results
        for document in querySnapshot!.documents {
            let childData = document.data()
            // Access child data here
            print("Child data:", childData)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
