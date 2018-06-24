
import UIKit

protocol GameInteractorAdaptor {
  
  func fetchCards(count: Int, _ onComplete: @escaping ([Artwork]?, String?) -> Void)
}

struct GameInteractor: GameInteractorAdaptor, NetworkRequest {  
  let service: NetworkAdaptor
  
  func fetchCards(count: Int, _ onComplete: @escaping ([Artwork]?, String?) -> Void) {
    let url = apiUri
    service.request(url) { (data, error) in
      do {
        guard let data = data else {
          if let error = error {
            onComplete(nil, Errors.network(description: error.localizedDescription).errorDescription)
          }
          return
        }
        let result = try JSONDecoder().decode(Tracks.self, from: data)
        
        if result.tracks.count < count {
          onComplete(nil, Errors.notEnoughImages.errorDescription)
        }
        
        if count > result.tracks.count {
          fatalError("The fetched json file has only \(result.tracks.count) artwork. Cards count should be less than \(result.tracks.count)")
        }
        
        guard let artworks = self.parse(tracks: result.tracks, count: count) else {
          onComplete(nil, Errors.cantDownloadImages.localizedDescription)
          return
        }
        
        DispatchQueue.main.async {
          onComplete(artworks, nil)
        }
      } catch {
        onComplete(nil, Errors.unknown.localizedDescription)
      }
    }
  }
  
  fileprivate func parse(tracks: [Track], count: Int) -> [Artwork]? {
    let tracksSlice = tracks[0..<count]
    
    let imageUrls = tracksSlice.map{$0.artworkUrl}
    var images = [(image: UIImage, url: String)]()
    for url in imageUrls {
      do {
        if let (image, url) = try downloadImage(url: url) {
          images.append((image, url))
        }
      } catch let error {
        print(error)
      }
    }
    
    if images.count == count {
      let parsedTracks = images.map({ Artwork(url: $0.url,
                                              image: $0.image)})
      return parsedTracks
    }
    return nil
  }
  
  fileprivate func downloadImage(url: String) throws  -> (UIImage, String)? {
    
    guard let imageURL = URL(string: url) else {
      throw(Errors.network(description: "Invalid image path"))
    }
    guard let imageData = try? Data(contentsOf: imageURL) else {
      throw(Errors.network(description: "Couldn't downlod image for path: \(imageURL)"))
    }
    
    guard let image = UIImage(data: imageData) else { return nil }
    return (image, url)
  }
}
