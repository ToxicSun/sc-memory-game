
@testable import MemoryGame
import Foundation

enum StubType: String {
  case tracks
}


protocol NetworkServiceStubProtocol {
  
  func get(resource: String, ext: String) -> Data?
}


class NetworkServiceStub: NetworkServiceStubProtocol {
  
  let stub: StubType
  init(stub: StubType) {
    self.stub = stub
  }
  
  func get(resource: String, ext: String) -> Data? {
    let bundle = Bundle(for: type(of: self))
    guard let file = bundle.url(forResource: resource, withExtension: ext),
      let data = try? Data(contentsOf: file) else {
        return nil
    }
    return data
  }
}


extension NetworkServiceStub: NetworkAdaptor {
  
  func request(_ url: String,
               method: RequestHTTPMethod = .get,
               parameters: [String : Any]? = nil,
               headers: [String: String]? = nil,
               onComplete: @escaping ((Data?, Error?) -> Void)) {
    
    onComplete (get(resource: stub.rawValue, ext: "json"), nil)
  }
  
}

