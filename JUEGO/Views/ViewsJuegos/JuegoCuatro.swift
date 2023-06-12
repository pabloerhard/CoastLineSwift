//
//  ContentView.swift
//  xylo1
//
//  Created by Leonardo Gonzalez on 19/05/23.
//

import SwiftUI
import AudioToolbox

struct XylophoneView: View {
    let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink]
    let notes: [String] = ["C", "D", "E", "F", "G", "A", "B"]
    let buttonSize: CGFloat = 70

    var body: some View {
        GeometryReader { geometry in
            let isHorizontal = geometry.size.width > geometry.size.height

            VStack(spacing: isHorizontal ? 8 : 20) {
                Spacer(minLength: 10)
                if isHorizontal {
                    HStack() {
                        Spacer(minLength: 0)
                        createButtons(width: geometry.size.width - 150, height: geometry.size.height - 200)
                        Spacer(minLength: 0)
                    }
                } else {
                    createButtons(width: geometry.size.width - 20, height: (geometry.size.height - 60) / CGFloat(notes.count) - 8)
                }
                Spacer(minLength: 10)
            }
            .padding(50)
            .background(LinearGradient(gradient: Gradient(colors: [.purple, .cyan]), startPoint: .top, endPoint: .bottom))
            //.edgesIgnoringSafeArea(.all)
        }
    }

    func createButtons(width: CGFloat, height: CGFloat) -> some View {
        HStack(spacing: 9) {
            ForEach(Array(zip(notes, colors)), id: \.0) { note, color in
                Button(action: {
                    playSound(note: note)
                }) {
                    Text(note)
                        .font(.system(size: 60, weight: .bold, design: .default))
                        .frame(width: width / CGFloat(notes.count) - 8, height: height)
                        .background(color)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                        .overlay(
                            Circle()
                                .frame(width: width * 0.6, height: height * 0.10)
                                .foregroundColor(.white)
                                .opacity(0.6)
                                .offset(y: -height * 0.4)
                        )
                        .overlay(
                            Circle()
                                .frame(width: width * 0.6, height: height * 0.10)
                                .foregroundColor(.white)
                                .opacity(0.6)
                                .offset(y: height * 0.4)
                        )
                }
            }
        }
    }


    func playSound(note: String) {
        guard let url = Bundle.main.url(forResource: note, withExtension: "wav") else {
            return
        }

        var soundID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
}

struct PianoView: View {
    let whiteKeys: [String] = ["C_piano", "D_piano", "E_piano", "F_piano", "G_piano", "A_piano", "B_piano"]
    let blackKeys: [String?] = ["CS_piano", "DS_piano", nil, "FS_piano", "GS_piano", "AS_piano"]

    var body: some View {
        GeometryReader { geometry in
            let keyWidth = geometry.size.width / CGFloat(whiteKeys.count)
            let blackKeyWidth = keyWidth * 0.6

            ZStack {
                createWhiteKeys(keyWidth: keyWidth, keyHeight: geometry.size.height)
                createBlackKeys(keyWidth: blackKeyWidth, keyHeight: geometry.size.height * 0.5, whiteKeyWidth: keyWidth)
            }
            .padding(10)
        }
        .scaleEffect(0.7) // scale the entire piano to 70%
        .background(LinearGradient(gradient: Gradient(colors: [.purple, .cyan]), startPoint: .top, endPoint: .bottom))
    }

    func createWhiteKeys(keyWidth: CGFloat, keyHeight: CGFloat) -> some View {
        HStack(spacing: 0) {
            ForEach(whiteKeys, id: \.self) { key in
                Button(action: {
                    playSound(note: key)
                }) {
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(width: keyWidth, height: keyHeight)
                        .cornerRadius(5)
                        .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 3)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 3)
                        )
                }
            }
        }
    }

    func createBlackKeys(keyWidth: CGFloat, keyHeight: CGFloat, whiteKeyWidth: CGFloat) -> some View {
        HStack(spacing: 0) {
            ForEach(blackKeys.indices, id: \.self) { index in
                if let key = blackKeys[index] {
                    Button(action: {
                        playSound(note: key)
                    }) {
                        Rectangle()
                            .foregroundColor(.black)
                            .frame(width: keyWidth, height: keyHeight)
                            .cornerRadius(5)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    }
                    .padding(.leading, (whiteKeyWidth - keyWidth) / 2)
                    .padding(.trailing, (whiteKeyWidth - keyWidth) / 2)
                } else {
                    Spacer()
                        .frame(width: whiteKeyWidth)
                }
            }
        }
        .offset(y: -keyHeight / 2)
    }

    func playSound(note: String) {
        guard let url = Bundle.main.url(forResource: note, withExtension: "wav") else {
            return
        }

        var soundID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
}

struct DrumView: View {
    let drumSounds: [String] = ["kick", "snare", "hi-hat", "tom", "crash"]
    let drumColors: [Color] = [.red, .blue, .green, .yellow, .orange]
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack {
                    DrumButton(sound: drumSounds[3], color: drumColors[3])
                    DrumButton(sound: drumSounds[4], color: drumColors[4])
                }
                Spacer()
                VStack {
                    DrumButton(sound: drumSounds[2], color: drumColors[2])
                    DrumButton(sound: drumSounds[1], color: drumColors[1])
                }
                Spacer()
            }
            Spacer()
            HStack {
                Spacer()
                DrumButton(sound: drumSounds[0], color: drumColors[0])
                Spacer()
            }
            Spacer()
        }
        .background(LinearGradient(gradient: Gradient(colors: [.purple, .cyan]), startPoint: .leading, endPoint: .trailing))
    }
}

struct DrumButton: View {
    let sound: String
    let color: Color
    
    var body: some View {
        Button(action: {
            playSound(sound: sound)
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(color)
                    .frame(width: 200, height: 120)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 3)
                    )
                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                
                Text(sound.prefix(1).uppercased() + sound.dropFirst())
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.system(size: 18))
            }
        }
        .padding(.horizontal, 20)
    }
    
    func playSound(sound: String) {
        if let soundURL = Bundle.main.url(forResource: sound, withExtension: "wav") {
            var soundID: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID)
            AudioServicesPlaySystemSound(soundID)
        }
    }
}

struct JuegoCuatro: View {
    @State private var selectedTab = 0
    @State private var showMainMenu = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                TabView(selection: $selectedTab) {
                    XylophoneView()
                        .tag(0)
                    
                    DrumView()
                        .tag(1)
                    
                    PianoView()
                        .tag(2)
                }
                .accentColor(.purple)
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
        .statusBar(hidden: true)
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarButton(systemImageName: "pianokeys", title: "Xylophone", tab: 0, selectedTab: $selectedTab)
            
            TabBarButton(systemImageName: "music.note", title: "Drums", tab: 1, selectedTab: $selectedTab)
            
            TabBarButton(systemImageName: "pianokeys", title: "Piano", tab: 2, selectedTab: $selectedTab)
        }
        .frame(height: 60)
        .padding(.top, 10)
        .background(Color.black.opacity(0.6))
    }
}

struct TabBarButton: View {
    let systemImageName: String
    let title: String
    let tab: Int
    @Binding var selectedTab: Int
    
    var body: some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack {
                Image(systemName: systemImageName)
                    .font(.title)
                    .foregroundColor(selectedTab == tab ? .purple : .white)
                Text(title)
                    .foregroundColor(selectedTab == tab ? .purple : .white)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct JuegoCuatro_Previews: PreviewProvider {
    static var previews: some View {
        JuegoCuatro()
    }
}



