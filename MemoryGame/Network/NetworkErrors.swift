
enum Errors: Error {
  case invalidJSON
  case network(description: String)
  case cantDownloadImages
  case notEnoughImages
  case unknown
}

extension Errors {
  var errorDescription: String {
    switch self {
    case .invalidJSON:
      return "Invalid JSON"
    case .network(description: let description):
      return description
    case .notEnoughImages:
      return "Not enough images"
    case .cantDownloadImages:
      return "Can't download image"
    case .unknown:
      return "Unknown error"
    }
  }
}
