//
//  AuthenticationViewModel.swift


import Foundation
import Firebase
import GoogleSignIn
import UIKit
import SwiftUI

class AuthenticationViewModel: ObservableObject {
    @Published var isLoginSuccesful = false
    func signInWithGoogle(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting:Application_utility.rootViewController) { user, error in
           
            if let error = error {
                print(error.localizedDescription)
                return
            }

          guard let user = user?.user,
            let idToken = user.idToken?.tokenString else {return}

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential){ res,error in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                guard let user = res?.user else {return}
                print(user)
                self.isLoginSuccesful=true
            }
        }
    }
    
    
}
