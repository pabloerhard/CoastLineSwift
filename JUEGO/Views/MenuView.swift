//
//  MenuView.swift
//  JUEGO
//
//  Created by Alumno on 22/05/23.
//

import SwiftUI
import SDWebImageSwiftUI

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
    @State private var showDeleteUserAlert = false
    @State private var image: Image? = Image("pinguino")
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    @State private var shouldSheetAlumno = false
    @State private var isDeleteConfirmed = false
    @State private var showDeleteConfirmation = false
    @State private var nombre : String = ""
    @State private var apellido : String = ""
    @State private var errorDelete : String = ""
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
                                        .font(.system(size:35))
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
                                        
                                        Button{
                                            showDeleteConfirmation = true
                                            if isDeleteConfirmed{
                                                do {
                                                    try repository.deleteUser()
                                                    userData.mostrarMenu = false
                                                    isCorrect=false
                                                    userData.isLogIn = false
                                                }catch let error{
                                                    errorDelete = error.localizedDescription
                                                    showDeleteUserAlert = true
                                                }
                                            }

                                        } label: {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(Color(red:34/255,green:146/255,blue:164/255))
                                                .frame(width:geo.size.width * 0.3,height: geo.size.height * 0.1)
                                                .overlay(Text("Borrar Cuenta"))
                                                .font(Font.custom("HelveticaNeue-Thin", size: 24))
                                                .foregroundColor(.white)
                                            
                                        }.alert(isPresented: $showDeleteUserAlert) {
                                            Alert(title: Text("Error"),message:Text(errorDelete),
                                                  dismissButton: .default(Text("OK")){
                                                showDeleteUserAlert=false
                                            })
                                        }
                                        .popover(isPresented: $showDeleteConfirmation) {
                                            VStack {
                                                    Text("Confirmar Eliminacion de Cuenta")
                                                        .font(Font.custom("HelveticaNeue-Thin", size: 20))
                                                        .padding()
                                                    
                                                    Text("¿Estas seguro?")
                                                        .font(Font.custom("HelveticaNeue-Thin", size: 16))
                                                        .padding()
                                                    
                                                    HStack {
                                                        Button(action: {
                                                            showDeleteConfirmation = false
                                                            isDeleteConfirmed = true
                                                        }) {
                                                            Text("Delete")
                                                                .font(Font.custom("HelveticaNeue-Thin", size: 16))
                                                                .foregroundColor(.red)
                                                        }
                                                        .padding()
                                                        
                                                        Button(action: {
                                                            showDeleteConfirmation = false
                                                        }) {
                                                            Text("Cancel")
                                                                .font(Font.custom("HelveticaNeue-Thin", size: 16))
                                                        }
                                                        .padding()
                                                    }
                                                }
                                                .padding()
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
                                        
                                        Text("Desliza hacia abajo para cerrar vista")
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                            .padding(.top)
                                        
                                        
                                    }
                                    .sheet(isPresented: $shouldSheetAlumno){
                                        EditAlumnoView()
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
                                
                            }
                            
                            Text("Bienvenido \(userData.curAlumno.Nombre)")
                                .font(Font.custom("HelveticaNeue-Thin", size: fontSize))
                                .onAppear {
                                    //debugPrint("Size Category:", sizeCategory)
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
        //print(index)
        if index == 0 {
            return AnyView(MenuPictogramasView())
        }
        if index == 1 {
            return AnyView(JuegoDos())
        }
        if index == 2{
            return AnyView(JuegoCuatro())
        }
        if index == 3{
            return AnyView(EmojiMatchingGameView())
        }
        if index==4{
            return AnyView(JuegoTres())
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
    @Environment(\.dismiss) var dismiss
    @Environment(\.dismiss) var dismiss1
    @State private var showAlert = false
    @State private var tempPictogramas = [Pictograma]()
    let repository = FirebaseService()
    @State private var errorMessage = ""
    @State private var isWatchingPictograma: [String: Bool] = [:]
    

    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack{
                    Form {
                        Text("Editar Alumno")
                            .font(.largeTitle)
                            .bold()
                        
                        Section(header: Text("Datos Personales")) {
                            LabeledContent {
                                TextField("Nombre", text: $userData.tempCurAlumnoInfo.Nombre)
                            } label: {
                                Text("Nombre: ")
                            }
                            LabeledContent {
                                TextField("Apellido", text: $userData.tempCurAlumnoInfo.Apellido)
                            } label: {
                                Text("Apellido: ")
                            }
                        }
                        
                        Section(header: Text("Informacion General")) {
                            LabeledContent {
                                Picker("", selection: $userData.tempCurAlumnoInfo.Nivel) {
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
                                Text("Tutor de \(userData.tempCurAlumnoInfo.Nombre): ")
                            }
                        }
                        Section(header: Text("Pictogramas Actuales")) {
                            if userData.tempCurAlumnoInfo.Pictogramas.isEmpty, pictogramas.isEmpty {
                                Text("Actualmente \(userData.tempCurAlumnoInfo.Nombre) No Tiene Pictogramas")
                            } else{
                                List {
                                    ForEach(userData.tempCurAlumnoInfo.Pictogramas, id: \.Nombre) { picto in
                                        VStack {
                                            Button {
                                                isWatchingPictograma[picto.Nombre] = false
                                                isWatchingPictograma[picto.Nombre]?.toggle()
                                            } label: {
                                                HStack {
                                                    Text(picto.Nombre)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .foregroundColor(.black)
                                                    Spacer()
                                                    Text("Pulsa para ver imagen")
                                                        .font(.caption2)
                                                        .foregroundColor(.gray)
                                                    WebImage(url: URL(string: picto.Image))
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 50, height: 50)
                                                        .cornerRadius(10)
                                                }
                                            }
                                            .sheet(isPresented: Binding(
                                                get: { isWatchingPictograma[picto.Nombre] ?? false },
                                                set: { isWatchingPictograma[picto.Nombre] = $0 }
                                            )) {
                                                VStack {
                                                    Text(picto.Nombre)
                                                        .font(.title2)
                                                        .bold()
                                                    HStack {
                                                        Spacer()
                                                        WebImage(url: URL(string: picto.Image))
                                                            .resizable()
                                                            .scaledToFit()
                                                            .cornerRadius(10)
                                                        Spacer()
                                                    }
                                                    Text("Desliza hacia abajo para cerrar vista")
                                                        .font(.caption2)
                                                        .foregroundColor(.gray)
                                                }
                                                .padding()
                                            }
                                        }
                                    }
                                    .onDelete { indices in
                                        userData.tempCurAlumnoInfo.Pictogramas.remove(atOffsets: indices)
                                    }
                                    ForEach(pictogramas, id: \.Nombre) { picto in
                                        VStack {
                                            if let imagen = picto.Image {
                                                Button {
                                                    isWatchingPictograma[picto.Nombre] = false
                                                    isWatchingPictograma[picto.Nombre]?.toggle()
                                                } label: {
                                                    HStack {
                                                        Text(picto.Nombre)
                                                            .frame(maxWidth: .infinity, alignment: .leading)
                                                            .foregroundColor(.black)
                                                        Spacer()
                                                        Text("Pulsa para ver imagen")
                                                            .font(.caption2)
                                                            .foregroundColor(.gray)
                                                        Image(uiImage: imagen)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 50, height: 50)
                                                            .cornerRadius(10)
                                                    }
                                                }
                                                .sheet(isPresented: Binding(
                                                    get: { isWatchingPictograma[picto.Nombre] ?? false },
                                                    set: { isWatchingPictograma[picto.Nombre] = $0 }
                                                )) {
                                                    VStack {
                                                        Text(picto.Nombre)
                                                            .font(.title2)
                                                            .bold()
                                                        HStack {
                                                            Spacer()
                                                            Image(uiImage: imagen)
                                                                .resizable()
                                                                .scaledToFit()
                                                                .cornerRadius(10)
                                                            Spacer()
                                                        }
                                                        Text("Desliza hacia abajo para cerrar vista")
                                                            .font(.caption2)
                                                            .foregroundColor(.gray)
                                                    }
                                                    .padding()
                                                }
                                            }
                                        }
                                    }
                                    .onDelete { indices in
                                        pictogramas.remove(atOffsets: indices)
                                    }
                                }
                            }
                        }
                        Section(header: Text("Agregar pictograma")) {
                            HStack {
                                Spacer()
                                Button {
                                    isAddingPicto.toggle()
                                } label: {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color(red:34/255,green:100/255,blue:164/255))
                                        .frame(height: geo.size.height * 0.1)
                                        .overlay(Text("Formulario de Pictogramas"))
                                        .font(Font.custom("HelveticaNeue-Thin", size: 24))
                                        .foregroundColor(.white)
                                }
                                Spacer()
                            }
                        }
                        
                    }
                    .navigationBarItems(trailing:
                                            Button(action: {
                        if isValidForm() {
                            var pictos: [Pictograma] = []
                            let uploadGroup = DispatchGroup()
                            for pictograma in pictogramas {
                                uploadGroup.enter()
                                repository.addImageToStorage(image: pictograma.Image!) { result in
                                    switch result {
                                    case .success(let urlString):
                                        print("Image uploaded successfully. URL: \(urlString)")
                                        pictos.append(Pictograma(Nombre: pictograma.Nombre, Image: urlString))
                                    case .failure(let error):
                                        errorMessage = "Error subiendo imagen a base de datos. Intente de nuevo"
                                        showAlert = true
                                        print("Error uploading image: \(error.localizedDescription)")
                                    }
                                    uploadGroup.leave()
                                }
                            }
                            uploadGroup.notify(queue: .main) {
                                for picto in pictos {
                                    userData.tempCurAlumnoInfo.Pictogramas.append(Pictograma(Nombre: picto.Nombre, Image: picto.Image))
                                }
                                print(userData.tempCurAlumnoInfo.Pictogramas)
                                Task {
                                    do {
                                        let updatedAlumno = try await repository.updateAlumno(alumno: userData.tempCurAlumnoInfo)
                                        userData.curAlumno = updatedAlumno
                                        print(updatedAlumno)
                                        Task {
                                            do {
                                                let alumnos = try await repository.getAlumnos()
                                                DispatchQueue.main.async {
                                                    userData.allAlumnos = alumnos
                                                }
                                                let filteredTutorAlumnos = alumnos.filter { alumno in
                                                    return alumno.Tutores.contains(userData.curTutor.Id)
                                                }
                                                userData.tutorAlumnos = filteredTutorAlumnos
                                                print("Alumnos de tutor extraidos correctamente \n")
                                                print("\(userData.tutorAlumnos) \n ")
                                                let filteredOtherAlumnos = alumnos.filter { alumno in
                                                    return !alumno.Tutores.contains(userData.curTutor.Id)
                                                }
                                                userData.otherAlumnos = filteredOtherAlumnos
                                                print("Resto de alumnos \n")
                                                print("\(userData.otherAlumnos) \n ")
                                            } catch {
                                                print("Error al obtener alumnos: \(error.localizedDescription)")
                                            }
                                        }
                                    } catch {
                                        // An error occurred while updating the alumno
                                        print("Error updating alumno: \(error)")
                                    }
                                    dismiss()
                                }
                            }
                            
                        } else {
                            showAlert = true
                        }
                    }) {
                        Text("Confirmar")
                    }
                    )
                    
                    .navigationBarItems(leading: Button(action: {
                        dismiss()
                    }) {
                        Text("Cancelar")
                    })
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Error"),
                            message: Text(errorMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
            }
            .onAppear{
                userData.tempCurAlumnoInfo = userData.curAlumno
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $shouldShowImagePicker) {
            ImagePicker(image: $image)
        }
        .sheet(isPresented: $isAddingPicto){
            AddPictogramaView(pictogramas: $pictogramas, usedNames: $usedNames)
        }
        
    }
    private func deletePictograma(at offsets: IndexSet, nombre: String) {
        pictogramas.remove(atOffsets: offsets)
        usedNames.remove(nombre)
    }
    
    private func isValidForm() -> Bool {
        return  !userData.tempCurAlumnoInfo.Nombre.isEmpty && !userData.tempCurAlumnoInfo.Apellido.isEmpty
    }
    
}


struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
