
@testable import MemoryGame
import XCTest

class CardViewModelTests: XCTestCase {
  
  var card: CardViewModel!

  override func setUp() {
    card = CardViewModel.init(id: mockedArtwork.url, image: mockedArtwork.image)
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testFlipped() {
    card.flip()
    XCTAssertTrue(card.isFlipped)
  }
  
  func testReset() {
    card.reset()
    XCTAssertFalse(card.isFlipped)
  }
  
  
  fileprivate lazy var mockedArtwork: Artwork = {
    return Artwork(url: "id1", image: UIImage(named: "artworkImage1.jpg", in: Bundle(for: type(of: self)), compatibleWith: nil)!)
  }()
  
}
