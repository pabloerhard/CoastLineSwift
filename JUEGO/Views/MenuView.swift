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
    @EnvironmentObject var userData : UserData
    @State private var showSignOutAlert = false
    @State private var showPerfilesView = false
    
    let repository = FirebaseService()
    
    var body: some View {
        if userData.mostrarMenu{
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
                                                sheetPresented = false
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
                            .sheet(isPresented: $isCorrect) {
                                
                                GeometryReader {geo in
                                    VStack(alignment: .center, spacing: 16) {
                                        Text ("Ajustes de Cuenta")
                                            .font(Font.custom("HelveticaNeue-Thin", size: 24))
                                        
                                        Button {
                                            do{
                                                
                                                try repository.signOut()
                                                userData.mostrarMenu = false
                                                isCorrect=false
                                                userData.isLogIn = false
                                                
                                            }catch{
                                                showSignOutAlert = true
                                            }
                                        } label: {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.black)
                                                .frame(width:geo.size.width * 0.3,height: geo.size.height * 0.1)
                                                .overlay(Text("Sign Out"))
                                                .font(Font.custom("HelveticaNeue-Thin", size: 24))
                                                .foregroundColor(.white)
                                            
                                        }
                                        .alert(isPresented: $showSignOutAlert) {
                                            Alert(title: Text("Error"),message:Text("Error haciendo el SignOut"),
                                                  dismissButton: .default(Text("OK")){
                                                showSignOutAlert=false
                                            })
                                        }
                                        Button {
                                            isCorrect = false
                                            userData.mostrarMenu = false
                                        } label: {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.black)
                                                .frame(width:geo.size.width * 0.3,height: geo.size.height * 0.1)
                                                .overlay(Text("Perfiles"))
                                                .font(Font.custom("HelveticaNeue-Thin", size: 24))
                                                .foregroundColor(.white)
                                        }
                                  
                                            
                                
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
                                
                            }
                            
                            Text("Bienvenido \(userData.curAlumno.Nombre)")
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
                                                    Group {
                                                        if index >= userData.curAlumno.Nivel {
                                                              Image(systemName: "lock")
                                                                  .foregroundColor(.white)
                                                                  .font(.system(size: fontSize * 1.5))
                                                          } else {
                                                              Text("Nivel: \(index+1)")
                                                                  .foregroundColor(.white)
                                                                  .font(Font.custom("HelveticaNeue-Thin", size: fontSize * 1.5))
                                                           }
                                                         }
                                                    
                                                )
                                                .frame(width: itemWidth,height: itemHeigth)
                                        }
                                        .disabled(index >= userData.curAlumno.Nivel)
                                        
                                    }
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                    
                    
                }
            }
            .navigationViewStyle(.stack)
            .navigationBarBackButtonHidden(true)
        } else {
            PerfilesView()
        }
       
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
        }
        if index == 2{
            return AnyView(JuegoTres())
        }
        if index == 3{
            return AnyView(JuegoCuatro())
        }else {

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
