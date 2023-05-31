//
//  MenuView.swift
//  JUEGO
//
//  Created by Alumno on 22/05/23.
//

import SwiftUI

struct MenuView: View {
    @Environment(\.sizeCategory) var sizeCategory
    @State private var columns = 2
    @State private var isToggled = false
    var body: some View {
        VStack {
            VStack{
                ZStack {
                    HStack{
                        Image(systemName: "gear")
                            .font(.system(size:40))
                            .padding()
                        Spacer()
                    }
                    Text("Menu Principal")
                        .font(Font.custom("HelveticaNeue-Thin", size: fontSize))
                        .onAppear {
                            debugPrint("Size Category:", sizeCategory)
                                  }
                }
                Toggle(isOn: $isToggled) {
                                Text("Toggle")
                            }
                            .onChange(of: isToggled) { newValue in
                                columns = newValue ? 4 : 2
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .red))
            
            }
            
            VStack {
                GeometryReader { geometry in
                    let itemWidth = geometry.size.width / CGFloat(columns)
                    let itemHeigth = geometry.size.height / 3
                    
                    ScrollView(.vertical) {
                        LazyVGrid(columns: CreateGridColumns(itemWidth: itemWidth,itemHeight:itemHeigth), spacing: 10) {
                                    ForEach(Array(0..<columns*6), id: \.self) { index in
                                        Button(){
                                            GoToGame(index: index)
                                            print(index)
                                        }label: {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.blue)
                                                .overlay(
                                                    Text("Nivel: \(index)")
                                                        .foregroundColor(.white)
                                                        .font(Font.custom("HelveticaNeue-Thin", size: fontSize*1.5))
                                                    
                                                )
                                                .frame(width: itemWidth,height: itemHeigth)
                                                
                                        }
                                    }
                                }
                        
                    }
                    
                }
                
            }
            
        }
            }
            
    func CreateGridColumns(itemWidth: CGFloat,itemHeight:CGFloat) -> [GridItem] {
                let gridItem = GridItem(.fixed(itemWidth))
                return Array(repeating: gridItem, count: columns)
            }
    
    func GoToGame(index: Int){
        if (index==1){
            print("Hola")
        }
    }
    
    var fontSize: CGFloat {
            switch sizeCategory {
            case .small:
                return 20
            case .medium:
                return 28
            case .large:
                return 45
            case .extraLarge:
                return 50
            default:
                return 30
            }
        }
    
    }


struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
