
import Foundation

protocol NetworkRequest {
  var headers: [String: String] { get }
  var apiUri: String { get }
}

extension NetworkRequest {
  
  var headers: [String: String] { return ["": ""] }
  var apiUri: String {
    let clientID = ""
		let baseURL = ""

		if baseURL.isEmpty {
			fatalError("Provide baseURL to be able to load game")
		}

    if clientID.isEmpty {
      fatalError("Provide ClientID to be able to load game")
    }

    return baseURL + clientID
  }
}
