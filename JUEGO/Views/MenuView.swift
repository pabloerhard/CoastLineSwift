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
        @State private var sheetPresented = false
        @State private var isCorrect = false
        @State private var respuesta = ""
        @State private var showAlert = false
        @State private var num1 = Int.random(in:0...9)
        @State private var num2 = Int.random(in:0...9)
        
        var body: some View {
            
            NavigationView {
                VStack {
                    VStack{
                        ZStack {
                            HStack {
                                Button {
                                    
                                    sheetPresented = true
                                } label: {
                                    Image(systemName: "person.2.badge.gearshape.fill")
                                        .font(.system(size:40))
                                }
                                .popover(isPresented: $sheetPresented){
                                    VStack{
                                        
                                        
                                        Text("Cuanto es \(num1) + \(num2)")
                                            .font(.title)
                                            .padding()
                                        TextField("Respuesta: ",text:$respuesta)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .padding()
                                        Button {
                                            if Int(respuesta) == num1 + num2{
                                                isCorrect=true
                                            }else{
                                                showAlert=true
                                            }
                                        } label: {
                                            Text("Revisar")
                                                .padding()
                                        }
                                        .alert(isPresented: $showAlert) {
                                            Alert(title: Text("Respuesta Incorrecta"),message:Text("Intenta de nuevo"),
                                                  dismissButton: .default(Text("OK")){
                                                showAlert=false
                                            })
                                        }
                                        .sheet(isPresented: $isCorrect) {
                                            
                                        }
                                        
                                    }
                                    .padding()
                                }
                                
                                
                                
                                Spacer()
                                Toggle(isOn: $isToggled) {
                                    HStack{
                                        Spacer()
                                        Text("Tamaño").symbolRenderingMode(/*@START_MENU_TOKEN@*/.hierarchical/*@END_MENU_TOKEN@*/)
                                            .font(Font.custom("HelveticaNeue-Thin", size: 24))
                                    }
                                            }
                                            .onChange(of: isToggled) { newValue in
                                                columns = newValue ? 4 : 2
                                            }
                                            .padding()
                                            .toggleStyle(SwitchToggleStyle(tint: .red))
                                
                                            
                                    }
                            
                            
                            
                            
                            Text("Menu Principal")
                                .font(Font.custom("HelveticaNeue-Thin", size: fontSize))
                                .onAppear {
                                    debugPrint("Size Category:", sizeCategory)
                                          }
                        }
                        
                    
                    }
                    
                    
                        VStack {
                            GeometryReader { geometry in
                                let itemWidth = geometry.size.width / CGFloat(columns)
                                let itemHeigth = geometry.size.height / 3
                                
                                ScrollView(.vertical) {
                                    LazyVGrid(columns: CreateGridColumns(itemWidth: itemWidth,itemHeight:itemHeigth), spacing: 10) {
                                                ForEach(Array(0..<columns*6), id: \.self) { index in
                                    
                                                    NavigationLink(destination:destinationView(for: index)){
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .foregroundColor(.blue)
                                                            .overlay(
                                                                Text("Nivel: \(index+1)")
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
            .navigationViewStyle(.stack)
                }
            
                
        func CreateGridColumns(itemWidth: CGFloat,itemHeight:CGFloat) -> [GridItem] {
                    let gridItem = GridItem(.fixed(itemWidth))
                    return Array(repeating: gridItem, count: columns)
                }
        
    func destinationView(for index: Int) -> some View {
        print(index)
        if index == 0 {
            return AnyView(MenuPictogramasView())
        }
        if index == 1 {
            return AnyView(JuegoDos())
        } else {
            // Return the default destination view if index doesn't match any specific condition
            return AnyView(MenuView())
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
