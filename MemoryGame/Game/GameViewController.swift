
import UIKit

class GameViewController: UIViewController {
  
  @IBOutlet weak var mainStackView: UIStackView!
  @IBOutlet weak var loadingLabel: UILabel!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var loadingView: UIView!
  
  fileprivate let gamePresenter = GamePresenter(gameGrid: (rows: 4, columns: 4), interactor: GameInteractor(service: NetworkService()))

  override func viewDidLoad() {
    super.viewDidLoad()
    gamePresenter.attachView(self)
    gamePresenter.notifyViewDidLoad()
  }
  
  fileprivate var indicies: [UIView: (row: Int, column: Int)] = [:]
  
  fileprivate func createRowStackView() -> UIStackView {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = mainStackView.spacing
    
    return stackView
  }
  
  fileprivate func resetStackView() {
    for row in mainStackView.arrangedSubviews {
      mainStackView.removeArrangedSubview(row)
      row.removeFromSuperview()
    }
  }
  
  @objc fileprivate func press(card: UITapGestureRecognizer) {
    let key = indicies.keys.filter { $0.gestureRecognizers?.contains(card) ?? false}.first
    guard let cardView = key,
      let index = indicies[cardView] else {
        fatalError ("No Card")
    }
    gamePresenter.flipCard(at: (index.row, index.column))
  }
}

extension GameViewController: GameView {
  
  func loadGame(cards: [[CardViewModel]], grid: (rows:Int, columns: Int)) {
    indicies.removeAll()
    resetStackView()
    for row in 0..<grid.rows {
      let rowStackView = createRowStackView()
      mainStackView.addArrangedSubview(rowStackView)
      
      for column in 0..<grid.columns {
        let cardView = gamePresenter.createCardView(at: row, column: column)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(press(card:)))
        cardView.addGestureRecognizer(recognizer)
        rowStackView.addArrangedSubview(cardView)
        indicies[cardView] = (row, column)
      }
    }
  }
  
  func showLoadingView() {
    self.loadingView.isHidden = false
    self.loadingLabel.text = "loading game..."
    self.activityIndicator.startAnimating()
  }
  
  func hideLoadingView() {
    self.loadingView.isHidden = true
    self.activityIndicator.stopAnimating()
  }
  
  func showEmptyView() {
    self.loadingView.isHidden = false
    self.loadingLabel.text = "No available artworks"
    self.activityIndicator.stopAnimating()
  }
  
  func showError(message: String) {
    UIAlertController.showAlert(message: message, from: self)
  }

}

