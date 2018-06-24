
import UIKit

protocol GameView: class {
  func loadGame(cards: [[CardViewModel]], grid: (rows:Int, columns: Int))
  func showLoadingView()
  func hideLoadingView()
  func showEmptyView()
  func showError(message: String)
}

class GamePresenter  {
  fileprivate let interactor: GameInteractorAdaptor!
  fileprivate var gameViewModel: GameViewModel?
  fileprivate weak var gameView: GameView?

  fileprivate var cardViewModels = [[CardViewModel]]()
  
  fileprivate let gameGrid: (rows:Int, columns: Int)
  
  init(gameGrid: (rows:Int, columns: Int), interactor: GameInteractorAdaptor) {
    self.gameGrid = gameGrid
    self.interactor = interactor
  }
  
  func notifyViewDidLoad() {
    self.gameView?.showLoadingView()
    self.fetchCards()
  }
  
  func attachView(_ view: GameView) {
    gameView = view
  }

  func createCardView(at row: Int, column: Int) -> CardView {
    
    let cardViewModel = cardViewModels[row][column]
    let cardView = CardView(image: cardViewModel.image)
    
    cardViewModel.transitionToLogoClosure = { [weak cardView] in
      cardView?.transitionToLogo()
    }
    cardViewModel.transitionToImageClosure = { [weak cardView] in
      cardView?.transitionToImage()
    }
    
    return cardView
  }
  
  func flipCard(at index:(row: Int, column: Int)) {
    let cardViewModel = self.cardViewModels[index.row][index.column]
    gameViewModel?.updateState(card: cardViewModel)
  }
  
  fileprivate var cardsCount: Int {
    return (gameGrid.rows * gameGrid.columns)/2
  }
  
  fileprivate func createNewGame(artworks: [Artwork]) {
    gameViewModel = GameViewModel(artworks: artworks, gameGrid: self.gameGrid)
    gameViewModel?.gameIsOverClosure = {
      self.newGame()
      return
    }
   newGame()
  }
  
  func newGame() {
    guard let gameBoard = self.gameViewModel?.gameBoard() else {
      fatalError("Unable to create game")
    }
    self.cardViewModels = gameBoard
    self.gameView?.loadGame(cards: self.cardViewModels,
                            grid: (self.gameGrid.rows, self.gameGrid.columns))
  }
}

extension GamePresenter {
  
  func fetchCards() {
    
    interactor.fetchCards(count: cardsCount) { [weak self] (artworks, errorDescription) in
      
      guard let `self` = self else { return }
      
      DispatchQueue.main.async {
        self.gameView?.hideLoadingView()
        if let artworks = artworks {
          self.createNewGame(artworks: artworks)
        } else if let errorDescription = errorDescription, errorDescription.isEmpty == false {
          self.gameView?.showError(message: errorDescription)
          self.gameView?.showEmptyView()
        } else {
          self.gameView?.showEmptyView()
        }
      }
    }
  }
  
}


