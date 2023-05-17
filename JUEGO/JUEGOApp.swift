//
//  JUEGOApp.swift
//  JUEGO
//
//  Created by Alumno on 26/04/23.
//

import SwiftUI
import Firebase

@main
struct JUEGOApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
