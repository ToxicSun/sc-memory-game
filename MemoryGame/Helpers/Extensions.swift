
import UIKit

extension UIView {
  func pinToSuperView() {
    guard let superview = superview else {
      fatalError("View has no superview")
    }
    self.translatesAutoresizingMaskIntoConstraints = false
    superview.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    superview.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    superview.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    superview.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
  }
}

extension MutableCollection {
  mutating func shuffle() {
    for i in indices.dropLast() {
      let diff = distance(from: i, to: endIndex)
      let j = index(i, offsetBy: numericCast(arc4random_uniform(numericCast(diff))))
      swapAt(i, j)
    }
  }
}

extension UIAlertController {
  
  static func showAlert(with title: String, message: String, from vc: UIViewController, completion: (() -> Void)?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
      completion?()
    }))
    
    vc.present(alert, animated: true, completion: nil)
  }
  
  static func showAlert(message: String, from vc: UIViewController) {
    showAlert(with: "", message: message, from: vc, completion: nil)
  }
}
