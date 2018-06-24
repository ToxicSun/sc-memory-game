
import UIKit

class GameViewModelMock: GameViewModel {
  
  convenience init() {
    self.init(artworks: [], gameGrid: (rows: 2, columns: 2))
  }
  
  override func gameBoard() -> [[CardViewModel]] {
   return self.mockBoard
  }
  
  var mockBoard: [[CardViewModel]] = []
  
}
