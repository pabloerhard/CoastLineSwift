//
//  JUEGOApp.swift
//  JUEGO
//
//  Created by Alumno on 26/04/23.
//

import SwiftUI
import Firebase
import GoogleSignIn


@main
struct JUEGOApp: App {
    @StateObject var userData = UserData()
    @StateObject var viewModel = AuthenticationViewModel()
    init(){
        setupAuthentication()
    }
    
    var body: some Scene {
        WindowGroup {
            SignInView()
                .preferredColorScheme(.light)
                .environmentObject(userData)
        }
    }
}
class AppDelegate:NSObject,UIApplicationDelegate{
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}



extension JUEGOApp{
    private func setupAuthentication(){
        FirebaseApp.configure()
    }
}
