
//
//  ContentView.swift
//  Puzzle
//
//  Created by Fer Cabrera on 22/05/23.
//

import SwiftUI

enum Difficulty {
    case easy, medium, hard
}

struct Tile: Identifiable {
    let id: Int
    var isCorrectPosition: Bool
}

class GameViewModel: ObservableObject {
    @Published var tiles: [Tile] = []
    @Published var difficulty: Difficulty = .easy
    var emptyTileIndex: Int = 0
    @Published var won = false
    
    init() {
        for i in 0..<9 {
            let tile = Tile(id: i, isCorrectPosition: i == 8)
            tiles.append(tile)
        }
        
        shuffleTiles()
    }
    
    func shuffleTiles() {
        tiles.shuffle()
        for (index, tile) in tiles.enumerated() {
            if tile.isCorrectPosition {
                emptyTileIndex = index
                break
            }
        }
    }
    
    func moveTile(at index: Int) {
        let isAdjacent: Bool
        switch difficulty {
        case .easy:
            isAdjacent = true
        case .medium:
            let row = index / 3
            let column = index % 3
            let emptyRow = emptyTileIndex / 3
            let emptyColumn = emptyTileIndex % 3
            isAdjacent = abs(row - emptyRow) + abs(column - emptyColumn) <= 2
        case .hard:
            let row = index / 3
            let column = index % 3
            let emptyRow = emptyTileIndex / 3
            let emptyColumn = emptyTileIndex % 3
            isAdjacent = abs(row - emptyRow) + abs(column - emptyColumn) == 1
        }
        
        if !tiles[index].isCorrectPosition && isAdjacent {
            let tempTile = tiles[index]
            tiles[index] = tiles[emptyTileIndex]
            tiles[emptyTileIndex] = tempTile
            emptyTileIndex = index
            checkWinCondition()
        }
    }
    
    func checkWinCondition() {
        for (index, tile) in tiles.enumerated() {
            if tile.id != index {
                won = false
                return
            }
        }
        won = true
    }
}

struct JuegoTres: View {
    @ObservedObject var viewModel = GameViewModel()
    
    var body: some View {
        ZStack {
            Color(red:245/255,green:239/255,blue:237/255)
            VStack {
                Text("Rompecabezas")
                    .font(Font.custom("HelveticaNeue-Thin", size: 50))
                    .padding()
                
                Picker("Difficulty", selection: $viewModel.difficulty) {
                    Text("Facil").tag(Difficulty.easy)
                    Text("Medio").tag(Difficulty.medium)
                    Text("Dificil").tag(Difficulty.hard)
                }
                .frame(width: 300)
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 1) {
                    ForEach(viewModel.tiles.indices, id: \.self) { index in
                        Button(action: {
                            viewModel.moveTile(at: index)
                        }) {
                            if viewModel.tiles[index].isCorrectPosition {
                                Rectangle()
                                    .fill(Color.blue)
                            } else {
                                Image("image\(viewModel.tiles[index].id)")
                                    .resizable()
                                    .frame(width: 200, height: 200)
                            }
                        }
                        .frame(width: 200, height: 200)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .font(.largeTitle)
                    }
                }
                .padding(.horizontal,380)
                
                Button {
                    viewModel.shuffleTiles()
                }label:{
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 200,height: 50)
                        .foregroundColor(.black)
                        .overlay {
                            Text("Mezclar")
                                .font(Font.custom("HelveticaNeue-Thin", size: 20))
                                .foregroundColor(.white)
                        }
                }
                .padding()
                
                if viewModel.won {
                    Text("¡Has ganado!")
                        .font(Font.custom("HelveticaNeue-Thin", size: 30))
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .ignoresSafeArea()
        .background(Color(red:245/255,green:239/255,blue:237/255))
        }
        .ignoresSafeArea()
    }
}

struct JuegoTres_Previews: PreviewProvider {
    static var previews: some View {
        JuegoTres()
    }
}

