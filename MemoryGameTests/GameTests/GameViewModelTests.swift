
@testable import MemoryGame
import XCTest

class GameViewModelTests: XCTestCase {
  
  let gameGrid = (rows: 2, columns: 2)
  var game: GameViewModelMock!

  override func setUp() {
    super.setUp()
    
    game = GameViewModelMock(artworks: [mockedArtwork1, mockedArtwork2], gameGrid: gameGrid)
    game.mockBoard = [[CardViewModel(id: mockedArtwork1.url, image: mockedArtwork1.image), CardViewModel(id: mockedArtwork2.url, image: mockedArtwork2.image)],
                      [CardViewModel(id: mockedArtwork1.url, image: mockedArtwork1.image), CardViewModel(id: mockedArtwork2.url, image: mockedArtwork2.image)]]
  }
  
  func testNumberOfCards() {
    XCTAssertEqual(game.mockBoard.count, (gameGrid.rows * gameGrid.columns)/2)
  }
  
  func testFlip() {
    let card = game.mockBoard[0][0]
    card.flip()
    XCTAssertTrue(card.isFlipped)
  }
  
  func testCardsMatch() {
    let cardViewModel1 = game.mockBoard[0][0]
    cardViewModel1.flip()
    let cardViewModel2 = game.mockBoard[1][0]
    cardViewModel2.flip()
    
    XCTAssertTrue(cardViewModel1.matches(cardViewModel2))
  }
  
  func testCardsNoMatch() {
    let cardViewModel1 = game.mockBoard[0][0]
    cardViewModel1.flip()
    let cardViewModel2 = game.mockBoard[0][1]
    cardViewModel2.flip()
    XCTAssertFalse(cardViewModel1.matches(cardViewModel2))
  }
  
  
  func testCardsReset() {
    let cardViewModel1 = game.mockBoard[0][0]
    cardViewModel1.flip()
    game.updateState(card: cardViewModel1)
    let cardViewModel2 = game.mockBoard[0][1]
    cardViewModel2.flip()
    game.updateState(card: cardViewModel2)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + AnimationTime.notMatch.rawValue) {
      XCTAssertFalse(cardViewModel1.isFlipped)
      XCTAssertFalse(cardViewModel2.isFlipped)
      XCTAssertEqual(self.game.state, GameViewModel.State.regular)
    }
  }
  
  func testInProgressState() {
    let cardViewModel = game.mockBoard[0][0]
    cardViewModel.flip()
    game.updateState(card: cardViewModel)
    XCTAssertEqual(game.state, GameViewModel.State.inProgress(previousCard:cardViewModel))
  }
  
  func testFinishedState() {
    
    // first round flip & match
    let cardViewModel1 = game.mockBoard[0][0]
    cardViewModel1.flip()
    game.updateState(card: cardViewModel1)
    let cardViewModel2 = game.mockBoard[1][0]
    cardViewModel2.flip()
    game.updateState(card: cardViewModel2)
    
    // second round flip & match
    let cardViewModel3 = game.mockBoard[0][1]
    cardViewModel3.flip()
    game.updateState(card: cardViewModel3)
    let cardViewModel4 = game.mockBoard[1][1]
    cardViewModel4.flip()
    game.updateState(card: cardViewModel4)
    
    XCTAssertEqual(game.state, GameViewModel.State.finished)
    DispatchQueue.main.asyncAfter(deadline: .now() + AnimationTime.newGame.rawValue) {
      XCTAssertEqual(self.game.state, GameViewModel.State.regular)
    }
  }
  
  fileprivate lazy var mockedArtwork1: Artwork = {
    return Artwork(url: "id1", image: UIImage(named: "artworkImage1.jpg", in: Bundle(for: type(of: self)), compatibleWith: nil)!)
  }()
  
  fileprivate lazy var mockedArtwork2: Artwork = {
    return Artwork(url: "id2", image: UIImage(named: "artworkImage2.jpg", in: Bundle(for: type(of: self)), compatibleWith: nil)!)
  }()
  
}
