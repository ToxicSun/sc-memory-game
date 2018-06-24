
import UIKit

class GameViewModel {
  
  fileprivate let artworks: [Artwork]
  fileprivate let gameGrid: (rows:Int, columns: Int)
  
  fileprivate var cardsMatrix = [[CardViewModel]]()
  
  init (artworks: [Artwork], gameGrid:(rows:Int, columns: Int) ) {
    
    if (gameGrid.rows * gameGrid.columns) % 2 != 0 {
      fatalError("Cards count should be even number")
    }

    self.artworks = artworks
    self.gameGrid = gameGrid
  }

  func gameBoard() -> [[CardViewModel]] {
    var allArtworks: [(String, UIImage)] = []
    
    for artwork in artworks {
      allArtworks.append((artwork.url, artwork.image))
    }
    
    allArtworks += allArtworks
    allArtworks.shuffle()
    
    let cards = allArtworks.map(CardViewModel.init)
    
    cardsMatrix = stride(from: 0,
                              to: cards.count,
                              by: gameGrid.columns)
      .map { Array(cards[$0..<($0 + gameGrid.columns)]) }
    return cardsMatrix
  }
  
  func updateState(card: CardViewModel) {
    switch state {
    case .regular:
      card.flip()
      state = .inProgress(previousCard: card)
    case .inProgress(previousCard: let previousCard):
      card.flip()
      state = .resolving
      checkForMatch(card1: previousCard, card2: card)
    default: break
    }
  }
  
  func checkForMatch(card1: CardViewModel, card2: CardViewModel) {
    if card1.matches(card2) {
      checkIfFinished()
    } else {
      DispatchQueue.main.asyncAfter(deadline: .now() + AnimationTime.notMatch.rawValue) {
        self.resetCards(card1: card1, card2: card2)
      }
    }
  }
  
  func resetCards(card1: CardViewModel, card2: CardViewModel) {
    card1.reset()
    card2.reset()
    state = .regular
  }
  
  func checkIfFinished() {
    let unflippedCards = cardsMatrix.flatMap{ $0 }.filter{ $0.isFlipped == false }
    state = unflippedCards.isEmpty ? .finished : .regular
    if state == .finished {
      DispatchQueue.main.asyncAfter(deadline: .now() + AnimationTime.newGame.rawValue) {
        self.gameIsOverClosure?()
        self.state = .regular
      }
    }
  }
  
  enum State {
    case regular
    case inProgress(previousCard: CardViewModel)
    case finished
    case resolving
  }
  
  fileprivate(set) lazy var state: State = .regular
  
  var gameIsOverClosure: (() -> Void)? = nil
}


extension GameViewModel.State: Equatable {
  
  static func == (l: GameViewModel.State, r: GameViewModel.State) -> Bool {
    switch (l, r) {
    case (.regular, .regular),
         (.finished, .finished),
         (.resolving, .resolving):
      return true
      
    case let (.inProgress(leftCard), .inProgress(rightCard)):
      return leftCard === rightCard
      
    default:
      return false
    }
  }
}

