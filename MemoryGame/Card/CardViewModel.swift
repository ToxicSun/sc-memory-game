
import UIKit

class CardViewModel {
  
  enum State {
    case regular
    case flipped
  }
  
  let image: UIImage
  let id: String
  
  init (id: String, image: UIImage) {
    self.id = id
    self.image = image
  }
  
  var state: State = .regular
  
  var isFlipped: Bool {
    if case .flipped = state {
      return true
    } else {
      return false
    }
  }
  
  func flip() {
    guard isFlipped == false else { return }
    transitionToImageClosure?()
    state = .flipped
  }
  
  func reset() {
    guard isFlipped else { return }
    transitionToLogoClosure?()
    state = .regular
  }
  
  func matches(_ card: CardViewModel) -> Bool {
    return self.id == card.id
  }
  
  var transitionToImageClosure: (() -> Void)? = nil
  var transitionToLogoClosure: (() -> Void)? = nil

}
