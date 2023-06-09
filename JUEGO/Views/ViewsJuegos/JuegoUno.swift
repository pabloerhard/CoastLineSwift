//
//  JuegoUno.swift
//  JUEGO
//
//  Created by Alumno on 26/05/23.
//

import SwiftUI
import AVFoundation



struct JuegoUno: View {
    let items: [String] // Assuming the array contains String items
    
    init(items: [String]) {
        self.items = items
    }
    
    
    @State private var isToggled = false
    @State private var sizePictogramas = 200
    @StateObject private var speechSynthesizer = SpeechSynthesizer()
    
    var body: some View {
        VStack {
            Toggle(isOn:$isToggled){
                HStack{
                    Spacer()
                    Text("Tamaño")
                        .font(Font.custom("HelveticaNeue-Thin", size: 24))
                }
            }
            .onChange(of: isToggled) { newValue in
                sizePictogramas = newValue ? 300 : 200
            }
            .toggleStyle(SwitchToggleStyle(tint: .red))
            .padding()
            
            ScrollView(.vertical){
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 300))
                ], spacing: 5) {
                    ForEach(items, id: \.self) {  item in
                        Image("\(item)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: CGFloat(sizePictogramas))
                            .padding(.vertical, 5)
                            .onTapGesture {
                                speechSynthesizer.speak(text: "\(item)")
                            }
                    }
                }
            }
        }
        .ignoresSafeArea()
        .background(Color(red:245/255,green:239/255,blue:237/255))
        
    }
    
}

struct JuegoUno_Previews: PreviewProvider {
    static var previews: some View {
        JuegoUno(items: ["vaca", "chango", "pez","pulpo"])
    }
}

