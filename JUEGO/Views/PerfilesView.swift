//
//  PerfilesView.swift
//  JUEGO
//
//  Created by Alumno on 26/05/23.
//

import SwiftUI
struct PerfilesView: View {
    @State private var mostrarAgregar =  false
    @State private var searchText = ""
    @EnvironmentObject var userData : UserData
    let columns: [GridItem] = [
        GridItem(spacing: 16),
        GridItem(spacing: 16),
        GridItem(spacing: 16)
    ]
    //var alumnos : [Alumno]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        if !userData.mostrarMenu{
            NavigationView {
                VStack(spacing: 0) {
                    Text("¡Hola, \(userData.curTutor.Nombre)!")
                        .font(Font.custom("HelveticaNeue-Thin", size: 35))
                        .bold()
                    Section(header: Text("Tus Datos Personales:")
                        .font(Font.custom("HelveticaNeue-Thin", size: 30))
                    ) {
                        Text("Nombre: \(userData.curTutor.Nombre)")
                            .font(Font.custom("HelveticaNeue-Thin", size: 20))
                        Text("Apellido: \(userData.curTutor.Apellido)")
                            .font(Font.custom("HelveticaNeue-Thin", size: 20))
                        Text("Cantidad de Alumnos: \(userData.tutorAlumnos.count)")
                    }
                    Spacer()
                    HStack {
                        TextField("Search", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 200)
                        
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    
                    ZStack(alignment:.center) {
                        Color(red: 175/255, green: 208/255, blue: 213/255)
                        
                        ScrollView {
                            if searchText == "" {
                                ForEach(Array(userData.otherAlumnos), id: \.self) { alumno in
                                    HStack {
                                        Spacer()
                                        Text(alumno.Nombre)
                                            .foregroundColor(.primary)
                                        
                                        Spacer() // Add spacer to push the button to the right
                                        
                                        Button(action: {
                                            userData.tutorAlumnos.insert(alumno)
                                            userData.otherAlumnos.remove(alumno)
                                        }) {
                                            Image(systemName: "plus")
                                                .padding(.trailing, 25)
                                        }
                                        .foregroundColor(.green)
                                    }
                                    .padding() // Add horizontal padding to the HStack
                                }
                            } else {
                                let filteredAlumnos = userData.otherAlumnos.filter { alumno in
                                    return alumno.Nombre.lowercased().contains(searchText.lowercased())
                                }
                                ForEach(Array(filteredAlumnos), id: \.self) { alumno in
                                    HStack {
                                        Spacer()
                                        Text(alumno.Nombre)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Button(action: {
                                            userData.tutorAlumnos.insert(alumno)
                                            userData.otherAlumnos.remove(alumno)
                                        }) {
                                            Image(systemName: "plus")
                                                .padding(.trailing, 25)
                                        }
                                        .foregroundColor(.green)
                                    }
                                    .padding() // Add horizontal padding to the HStack
                                }
                                
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .background(Color(red:245/255,green:239/255,blue:237/255))
                    }
                    
                    .ignoresSafeArea()
                }
                .background(Color(red: 175/255, green: 208/255, blue: 213/255))
                //.background(Color.clear)
                
                
                
                
                .toolbar {
                    Button {
                        mostrarAgregar = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $mostrarAgregar, onDismiss: {
                        // Handle data from the sheet here if needed
                    }) {
                        //AddAlumno(alumnos: alumnos)
                    }
                }
                .background(Color(red:34/255,green:146/255,blue:164/255))
                ScrollView {
                    Text("Lista de Alumnos de: \(userData.curTutor.Nombre)")
                        .font(Font.custom("HelveticaNeue-Thin", size: 50))
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(Array(userData.tutorAlumnos), id: \.self) { alumno in
                            
                            ProfileView(alumno: alumno)
                        }
                    }
                    .background(Color.clear)
                    .padding(16)
                }
                .background(Color(red:245/255,green:239/255,blue:237/255))
            }
            .background(Color(red: 175/255, green: 208/255, blue: 213/255))
            
            
        }
        else{
            MenuView()
        }
    }
    
}

struct ProfileView: View {
    let alumno: Alumno
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        Button {
            userData.curAlumno = alumno
            userData.mostrarMenu = true
        }label: {
            VStack(alignment: .center) {
                Text(alumno.Nombre)
                    .font(Font.custom("HelveticaNeue-Thin", size: 24))
                    .foregroundColor(.white)
                
                Text(alumno.Apellido)
                    .font(Font.custom("HelveticaNeue-Thin", size: 24))
                    .foregroundColor(.white)
                
                Text("Nivel: \(alumno.Nivel)")
                    .font(Font.custom("HelveticaNeue-Thin", size: 20))
                    .foregroundColor(.white)
                
            }
            .padding()
            .frame(minWidth: 50,maxWidth: .infinity,minHeight:30,maxHeight:.infinity)
            .background(Color(red:34/255,green:146/255,blue:164/255))
            .cornerRadius(10)
            .shadow(radius: 2)
        }
        .contextMenu {
            Button(action: {
                let filteredAlumnos = userData.tutorAlumnos.filter { tutorAlumno in
                    return tutorAlumno.Id != alumno.Id
                }
                userData.tutorAlumnos = filteredAlumnos
                userData.otherAlumnos.insert(alumno)
            }) {
                Label("Eliminar", systemImage: "trash")
            }
            Button(action: {
                // Perform action 2
            }) {
                Label("Editar", systemImage: "pencil")
            }
            // Add more buttons for additional actions as needed
        }
    }
}

struct NavigationTitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("HelveticaNeue-Thin", size: 35))
            .foregroundColor(.black)
            .fontWeight(.bold)
    }
}




struct PerfilesView_Previews: PreviewProvider {
    static var previews: some View {
        PerfilesView()
    }
}
