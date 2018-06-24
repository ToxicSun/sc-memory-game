
import Foundation

enum RequestHTTPMethod: String {
  case get = "GET"
}

protocol NetworkAdaptor {
  
  func request(_ url: String,
               method: RequestHTTPMethod,
               parameters: [String: Any]?,
               headers: [String: String]?,
               onComplete: @escaping ((Data?, Error?) -> Void))
}

extension NetworkAdaptor {
  
  func request(_ url: String,
               method: RequestHTTPMethod = .get,
               parameters: [String : Any]? = nil,
               headers: [String: String]? = nil,
               onComplete: @escaping ((Data?, Error?) -> Void)) {
    
    request(url, method: method,
            parameters: parameters,
            headers: headers,
            onComplete: onComplete)
  }
}
