//
//  Application.swift
//  JUEGO
//
//  Created by Alumno on 19/05/23.
//

import Foundation
import UIKit
import SwiftUI

final class Application_utility {
    static var rootViewController: UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return.init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
}
