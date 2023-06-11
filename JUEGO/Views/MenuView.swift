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
    @State private var image: Image? = Image("pinguino")
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    @State private var shouldSheetAlumno = false
    @State private var nombre : String = ""
    @State private var apellido : String = ""
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
                                                .foregroundColor(Color(red:34/255,green:146/255,blue:164/255))
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
                                                .foregroundColor(Color(red:34/255,green:146/255,blue:164/255))
                                                .frame(width:geo.size.width * 0.3,height: geo.size.height * 0.1)
                                                .overlay(Text("Perfiles"))
                                                .font(Font.custom("HelveticaNeue-Thin", size: 24))
                                                .foregroundColor(.white)
                                        }
                                        
                                        Button {
                                            //self.shouldPresentActionScheet = true
                                            shouldSheetAlumno=true
                                        }label:{
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(Color(red:34/255,green:146/255,blue:164/255))
                                                .frame(width:geo.size.width * 0.3,height: geo.size.height * 0.1)
                                                .overlay(Text("Cuenta del Alumno"))
                                                .font(Font.custom("HelveticaNeue-Thin", size: 24))
                                                .foregroundColor(.white)
                                        }
                                        
                                        
                                    }
                                    .sheet(isPresented: $shouldSheetAlumno){
                                        EditAlumnoView(geo: geo)
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
                                                .foregroundColor(Color(red:34/255,green:146/255,blue:164/255))
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
                                                .padding()
                                        }
                                        .disabled(index >= userData.curAlumno.Nivel)
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }.padding()
                    
                    
                    
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
        if index == 3{
            return AnyView(JuegoTres())
        }
        if index == 2{
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

struct EditAlumnoView: View {
    @EnvironmentObject var userData: UserData
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentCamera = false
    @State private var shouldPresentActionSheet = false
    @State private var shouldShowImagePicker = false
    @State private var isAddingPicto = false
    @State var image : UIImage?
    @State private var pictogramas = [PictogramaDto]()
    @State private var usedNames: Set<String> = []
    var geo: GeometryProxy
//    @State private var image: Image?

    var body: some View {
        VStack {
            Form {
                Text("Editar Alumno")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                Section(header: Text("Datos Personales")) {
                    LabeledContent {
                        TextField("Nombre", text: $userData.curAlumno.Nombre)
                    } label: {
                        Text("Nombre: ")
                    }
                    LabeledContent {
                        TextField("Apellido", text: $userData.curAlumno.Apellido)
                    } label: {
                        Text("Apellido: ")
                    }
                }

                Section(header: Text("Informacion General")) {
                    LabeledContent {
                        Picker("", selection: $userData.curAlumno.Nivel) {
                            ForEach(1...6, id: \.self) { nivel in
                                Text("\(nivel)")
                            }
                        }
                    } label: {
                        Text("Nivel Actual: ")
                    }
                    
                    LabeledContent {
                        TextField("Tutor", text: .constant("\(userData.curTutor.Nombre) \(userData.curTutor.Apellido) - (Tutor Actual)"))
                            .foregroundColor(.gray)
                            .disabled(true)
                    } label: {
                        Text("Tutor de \(userData.curAlumno.Nombre): ")
                    }
                }

                Section(header: Text("Agregar pictograma")) {
                    Button{
                        isAddingPicto.toggle()
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color(red:34/255,green:146/255,blue:164/255))
                            .frame(width:geo.size.width * 0.3,height: geo.size.height * 0.1)
                            .overlay(Text("Pictogramas"))
                            .font(Font.custom("HelveticaNeue-Thin", size: 24))
                            .foregroundColor(.white)
                    }
                }
                List {
                    ForEach(pictogramas) { picto in
                        VStack{
                            Text(picto.Nombre)
                        }
                    }
                    .onDelete{ indexSet in
                        for index in indexSet {
                            let nombre = pictogramas[index].Nombre
                            deletePictograma(at: indexSet, nombre: nombre)
                        }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $shouldShowImagePicker) {
            ImagePicker(image: $image)
        }
        .sheet(isPresented: $isAddingPicto){
            AddPictogramaView(pictogramas: $pictogramas, usedNames: $usedNames, geo: geo)
        }
    }
    private func deletePictograma(at offsets: IndexSet, nombre: String) {
        pictogramas.remove(atOffsets: offsets)
        usedNames.remove(nombre)
    }
    
}


struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
