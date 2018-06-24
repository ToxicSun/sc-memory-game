
import Foundation

struct NetworkService: NetworkAdaptor {
  
  private let session = URLSession.shared
  
  func request(_ url: String,
               method: RequestHTTPMethod = .get,
               parameters: [String : Any]? = nil,
               headers: [String: String]? = nil,
               onComplete: @escaping ((Data?, Error?) -> Void)) {
    
    guard let url = URL(string: url) else {
      onComplete(nil, nil)
      return
    }
    
    var request = URLRequest(url: url,
                             cachePolicy: .reloadIgnoringLocalCacheData,
                             timeoutInterval: 30)
    request.httpMethod = method.rawValue
    
    session.dataTask(with: request) { (data, response, error) in
      guard let data = data else {
        onComplete(nil, error)
        return
      }
      onComplete(data, nil)
      }.resume()
  }
}
