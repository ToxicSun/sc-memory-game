
import UIKit

class CardImageView: UIImageView {
  
  override init(image: UIImage?) {
    super.init(image: image)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func layoutSubviews() {
    self.contentMode = .scaleAspectFit
    self.layer.borderColor = UIColor.red.cgColor
    self.layer.cornerRadius = 1.0
    self.layer.borderWidth = 1.0
    self.clipsToBounds = true
  }
}
