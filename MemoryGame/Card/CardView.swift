
import UIKit

class CardView: UIView {
  
  fileprivate var image: UIImage!
  
  init(image: UIImage) {
    super.init(frame: .zero)
    self.image = image
    
    addSubview(faceImageView)
    addSubview(backImageView)
    faceImageView.pinToSuperView()
    backImageView.pinToSuperView()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  fileprivate lazy var backImageView: CardImageView = {
    let imageView = CardImageView(image: UIImage(named: "sc_logo"))
    imageView.isHidden = false
    return imageView
  }()
  
  fileprivate lazy var faceImageView: CardImageView = {
    let imageView = CardImageView(image: self.image)
    imageView.isHidden = true
    return imageView
  }()
  
}

typealias CardViewAnimations = CardView
extension CardViewAnimations {

  func transitionToLogo() {
    
    UIView.transition(from: faceImageView,
                      to: backImageView,
                      duration: AnimationTime.unflip.rawValue,
                      options: [.transitionFlipFromLeft, .showHideTransitionViews],
                      completion: nil)
  }
  
  func transitionToImage() {
    
    UIView.transition(from: backImageView,
                      to: faceImageView,
                      duration: AnimationTime.flip.rawValue,
                      options: [.transitionFlipFromRight, .showHideTransitionViews],
                      completion: nil)
  }
}
