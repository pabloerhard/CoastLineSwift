//
//  JuegoUno.swift
//  JUEGO
//
//  Created by Alumno on 26/05/23.
//

import SwiftUI
import AVFoundation
import SDWebImageSwiftUI


struct JuegoUno: View {
    let items: [String]
    
    init(items: [String]) {
        self.items = items
    }
    
    @State private var showInstrucciones = true
    @State private var isToggled = false
    @State private var sizePictogramas = 200
    @StateObject private var speechSynthesizer = SpeechSynthesizer()
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        NavigationView {
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
                        if !items.isEmpty {
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
                        } else {
                            ForEach(userData.curAlumno.Pictogramas, id: \.Nombre) {  picto in
                                WebImage(url: URL(string: picto.Image))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: CGFloat(sizePictogramas))
                                    .padding(.vertical, 5)
                                    .cornerRadius(15)
                                    .onTapGesture {
                                        speechSynthesizer.speak(text: picto.Nombre)
                                    }
                            }
                        }
                    }
                }
                .sheet(isPresented: $showInstrucciones, content: {
                    VStack {
                        
                        Text("Da click en cualquiera de los pictogramas para escuchar su representacion")
                            .font(Font.custom("HelveticaNeue-Thin", size: 20))
                            .padding()
                        Button{
                            showInstrucciones=false
                        }label: {
                            Text("Entendido")
                                .font(Font.custom("HelveticaNeue-Thin", size: 16))
                                
                        }
                        .padding()
                    }
                })
            }

            
        .background(Color(red:245/255,green:239/255,blue:237/255))
        }
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(.stack)
        
    }
    
}

struct JuegoUno_Previews: PreviewProvider {
    static var previews: some View {
        JuegoUno(items: ["vaca", "chango", "pez","pulpo"])
    }
}

