
import SwiftUI

struct EmojiContainer: View {
    let emoji: Emoji
    @ObservedObject var viewModel: EmojiViewModel
    private let regularSize: CGFloat = 100
    private let highlightedSize: CGFloat = 130
    
    var body: some View {
        ZStack{
            Text(emoji.emoji)
                .font(.system(size: regularSize))
            if viewModel.isHighlighted(emoji: emoji.emoji) {
                Text(emoji.emoji)
                    .font(.system(size: highlightedSize))
                    .opacity(0.5)
            }
        }
        .overlay {
            GeometryReader { proxy -> Color in
                viewModel.update(
                    frame: proxy.frame(in: .global),
                    for: emoji.emoji
                )
                
                return Color.clear
            }
        }
        .frame(width: highlightedSize, height: highlightedSize)
    }
}


struct DraggableEmoji: View {
    let emoji: Emoji
    let position: CGPoint
    private let size: CGFloat = 100

    @EnvironmentObject var viewModel: EmojiViewModel

    var body: some View {
        Text(emoji.emoji)
            .font(.system(size: size))
            .shadow(radius: 10)
            .position(position)
            .gesture(DragGesture()
                        .onChanged { state in
                            viewModel.update(dragPosition: state.location)
                        }
                        .onEnded { state in
                            viewModel.update(dragPosition: state.location)
                            withAnimation {
                                viewModel.confirmWhereEmojiWasDropped()
                            }
                        }
            )
    }
}


struct EmojiMatchingGameView: View {
    @StateObject private var viewModel = EmojiViewModel()
    @State private var showInstrucciones = true
    let gridItems = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { state in
                viewModel.update(dragPosition: state.location)
            }
            .onEnded { state in
                viewModel.update(dragPosition: state.location)
                withAnimation {
                    viewModel.confirmWhereEmojiWasDropped()
                }
            }
    }
    
    var body: some View {
        
        VStack {
            Button{
                //
            }label: {
                Text("")
            }
           
            
            ZStack {
                
                Text("Puntos: \(viewModel.score)")
                    .font(Font.custom("HelveticaNeue-Thin", size: 35))
                    .padding()

                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 10) {
                    ForEach(viewModel.emojiContainers, id: \.self) { emoji in
                        EmojiContainer(
                            emoji: emoji,
                            viewModel: viewModel
                        )
                    }
                }
                .sheet(isPresented: $showInstrucciones, content: {
                    VStack{
                        Text("Deberas arrastar el emoji a su posicion indicada")
                            .font(Font.custom("HelveticaNeue-Thin", size: 20))
                            .padding()
                        Text("La posicion indicada es aquella donde se encuentra el mismo emoji")
                            .font(Font.custom("HelveticaNeue-Thin", size: 20))
                        Button{
                            showInstrucciones=false
                        }label: {
                            Text("Entendido")
                                .font(Font.custom("HelveticaNeue-Thin", size: 20))
                                .padding()
                        }
                        
                    }
                    .padding()
                    .presentationDetents([.fraction(0.4)])
                })
                .padding()
                if let currentEmoji = viewModel.currentEmoji {
                    DraggableEmoji(
                        emoji: currentEmoji,
                        position: viewModel.currentPosition
                    )
                    .environmentObject(viewModel)

                    }
                }
            
            .frame(
                  minWidth: 0,
                  maxWidth: .infinity,
                  minHeight: 0,
                  maxHeight: .infinity,
                  alignment: .topLeading
                )
            .offset(y:-85)

            Button(action: {
                viewModel.generateNewGame()
                }) {
                    Text("Reiniciar")
                        .padding(20)
                        .background(Color(red:34/255,green:146/255,blue:164/255))
                        .foregroundColor(.white)
                        .font(.title)
                }
                
            .cornerRadius(20)
            .offset(y:-50)
            
        }

        .ignoresSafeArea()
        .background(Color(red:245/255,green:239/255,blue:237/255))
        
        

        }
    }

