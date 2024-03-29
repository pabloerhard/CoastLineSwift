//
//  MenuPictogramasView.swift
//  JUEGO
//
//  Created by Alejandro on 05/06/23.
//

import SwiftUI

struct MenuPictogramasView: View {
    var body: some View {
        @State var animalArray = ["pinguino","ardilla","chango","gallo","loro","mariposa","perro"
        ,"pulpo","pez","vaca","lobo","cerdo","oso","ballena","tiburon","foca"]
        @State var diasArray = ["martes","lunes","viernes","jueves","miercoles","sabado","semana","domingo"]
        @State var familiaArray = ["hermano","abuela","mama","hermana","abuelo","papa","padres","familia"]
        
        NavigationView {
        GeometryReader { geo in
            
            
                VStack {
                    Spacer()
                    Text("Menu Pictogramas")
                        .font(Font.custom("HelveticaNeue-Thin", size: 80))
                    HStack {
                        Spacer()
                        NavigationLink(destination:JuegoUno(items: animalArray)){
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color(red:34/255,green:146/255,blue:164/255))
                                    .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.4)
                                Image(systemName: "pawprint.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.3)
                                    .foregroundColor(.white)
                        }
                        
                        }
                        NavigationLink(destination:JuegoUno(items: familiaArray)){
                            ZStack {
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color(red:34/255,green:146/255,blue:164/255))
                                    .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.4)
                                Image(systemName: "figure.2.and.child.holdinghands")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.3)
                                    .foregroundColor(.white)
                            }
                        }
                        NavigationLink(destination:JuegoUno(items: diasArray)){
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color(red:34/255,green:146/255,blue:164/255))
                                    .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.4)
                                Image(systemName: "calendar")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.3)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Spacer()
                    }
                    HStack{
                        NavigationLink(destination:JuegoUno(items: [])){
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color(red:34/255,green:146/255,blue:164/255))
                                    .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.4)
                                Image(systemName: "photo.stack")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.3)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    Spacer()
                }
                .ignoresSafeArea()
                .background(Color(red:245/255,green:239/255,blue:237/255))
        }
        }
        .navigationBarBackButtonHidden(false)
        .navigationViewStyle(.stack)
    }
    
    
}

struct MenuPictogramasView_Previews: PreviewProvider {
    static var previews: some View {
        MenuPictogramasView()
    }
}
