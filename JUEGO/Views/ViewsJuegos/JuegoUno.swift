//
//  JuegoUno.swift
//  JUEGO
//
//  Created by Alumno on 26/05/23.
//

import SwiftUI

struct JuegoUno: View {
    let items: [String] // Assuming the array contains String items
    
    init(items: [String]) {
        self.items = items
    }
    
    @State private var isToggled = false
    @State private var sizePictogramas = 200
    
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
                    }
                }
            }
        }
    }
    
}

struct JuegoUno_Previews: PreviewProvider {
    static var previews: some View {
        JuegoUno(items: ["vaca", "chango", "pez","pulpo"])
    }
}

