//
//  ContentView.swift
//  escogeColorLv2
//
//  Created by Marcelo on 07/06/23.
//

import SwiftUI
import AVFoundation

class SpeechSynthesizer: ObservableObject {
    let synthesizer = AVSpeechSynthesizer()
    
    func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.4
        utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
        synthesizer.speak(utterance)
    }
}

func randomColor() -> Color {
    let colores: [Color] = [.red, .green, .blue, .orange, .yellow, .purple, .gray, .white]
    return colores.randomElement()!
}

func randomOptions(including colorCorrecto: Color) -> [Color] {
    var opciones: [Color] = [colorCorrecto]
    while opciones.count < 4 {
        let opcionColor = randomColor()
        if !opciones.contains(opcionColor) {
            opciones.append(opcionColor)
        }
    }
    return opciones.shuffled()
}

struct JuegoDos: View {
    
    @StateObject private var speechSynthesizer = SpeechSynthesizer()
    @State private var puntaje = 0
    @State private var colorCorrecto = randomColor()
    @State private var opciones: [Color] = []
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.mint, .cyan, .mint]), startPoint: .trailing, endPoint: .leading)
            VStack {
                Button (colorCorrectoEspaniol()) {
                    speechSynthesizer.speak(text: colorCorrectoEspaniol())
                }
                .foregroundColor(colorCorrecto)
                .font(.custom("Avenir", size: 80))
                .bold()
                .shadow(color: .black, radius: 1)
                
                Text("Puntaje : \(puntaje)")
                    .font(.largeTitle)
                LazyVGrid(columns: [
                    GridItem(spacing: 16),
                    GridItem(spacing: 16)
                ], spacing: 16) {
                    ForEach(opciones, id: \.self) { color in
                        Button(action: {
                            checkAnswer(color)
                        }) {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(color)
                                .frame(height: 200)
                                .border(.black, width: 3)
                        }
                    }
                }
                .padding()
            }
            .onAppear {
                opciones = randomOptions(including: colorCorrecto)
        }
        }
        .ignoresSafeArea()
    }
    
    private func checkAnswer(_ colorSeleccionado: Color) {
        if colorSeleccionado == colorCorrecto {
            puntaje += 1
            colorCorrecto = randomColor()
            opciones = randomOptions(including: colorCorrecto)
            speechSynthesizer.speak(text: colorCorrectoEspaniol())
        }
    }
    
    private func colorCorrectoEspaniol() -> String {
        switch colorCorrecto {
            case .red:
                return "ROJO"
            case .green:
                return "VERDE"
            case .blue:
                return "AZUL"
            case .orange:
                return "NARANJA"
            case .yellow:
                return "AMARILLO"
            case .purple:
                return "MORADO"
            case .gray:
                return "GRIS"
            case .white:
                return "BLANCO"
            default:
                return "COLOR"
        }
    }
}


struct JuegoDos_Previews: PreviewProvider {
    static var previews: some View {
        JuegoDos()
    }
}

