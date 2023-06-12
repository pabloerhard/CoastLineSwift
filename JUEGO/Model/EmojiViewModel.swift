import SwiftUI

class EmojiViewModel: ObservableObject {
    // GESTOS
    @Published var currentEmoji: Emoji?
    @Published var currentPosition = initialPosition
    @Published var highlightedEmoji: String?
    @Published var draggableEmojiOpacity: CGFloat = 1.0
    @Published var isGameOver = false
    @Published var score = 0
    private(set) var attempts = 0
    
    init() {
            generateNewGame()
        }
    
    // COORDENADAS
    private static let initialPosition = CGPoint(
        x: UIScreen.main.bounds.midX,
        y: UIScreen.main.bounds.maxY - 300
    )
    private var frames: [String: CGRect] = [:]
    
    // RENDER
    private var emojis = Array(Emoji.all.shuffled().prefix(upTo: 3))
    var emojiContainers = Emoji.all.shuffled()
    
    // CICLO DE JUEGO
    func confirmWhereEmojiWasDropped() {
        defer { highlightedEmoji = nil }
        
        guard let highlightedEmoji = highlightedEmoji else {
            resetPosition()
            return
        }
        
        if highlightedEmoji == currentEmoji?.emoji {
            score += 1
            setCurrentPositionToHighlightedContainer(WithEmoji: highlightedEmoji)
            generateNextRound()
        } else {
            resetPosition()
        }
        
        attempts += 1
    }

    func resetPosition() {
        currentPosition = EmojiViewModel.initialPosition
    }
    
    func setCurrentPositionToHighlightedContainer(WithEmoji emoji: String) {
        guard let frame = frames[emoji] else {
            return
        }
        currentPosition = CGPoint(x: frame.midX, y: frame.midY)
        makeEmojiInvisible()
    }
    
    func makeEmojiInvisible() {
        draggableEmojiOpacity = 0
    }
    
    func generateNextRound() {
        setNextEmoji()
        
        if currentEmoji == nil {
            gameOver()
        } else {
            prepareObjects()
        }
    }
    
    
    func setNextEmoji() {
        if let randomEmoji = emojiContainers.randomElement() {
            currentEmoji = randomEmoji
        }
    }

    func gameOver() {
        isGameOver = true
    }
    
    func prepareObjects() {
        shuffleEmojiContainersWithAnimation()
        resetCurrentEmojiWithoutAnimation()
    }
    
    func shuffleEmojiContainersWithAnimation() {
        withAnimation {
            emojiContainers.shuffle()
        }
    }
    
    func resetCurrentEmojiWithoutAnimation() {
        withAnimation(.none) {
            resetPosition()
            restoreOpacityWithAnimation()
        }
    }
    
    func restoreOpacityWithAnimation() {
        withAnimation {
            draggableEmojiOpacity = 1.0
        }
    }
    
    func generateNewGame() {
        emojis = Array(Emoji.all.shuffled().prefix(4))
        emojiContainers = emojis
        attempts = 0
        score = 0
        generateNextRound()
    }


    
    // UPDATES
    func update(frame: CGRect, for emoji: String) {
        frames[emoji] = frame
    }
    
    func update(dragPosition: CGPoint) {
        currentPosition = dragPosition
        for (emoji, frame) in frames where frame.contains(dragPosition) {
            highlightedEmoji = emoji
            return
        }
        
        highlightedEmoji = nil
    }
    
    func isHighlighted(emoji: String) -> Bool {
        highlightedEmoji == emoji
    }
}

