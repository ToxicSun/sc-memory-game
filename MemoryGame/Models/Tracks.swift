
import UIKit

struct Tracks: Decodable {
  let tracks: [Track]
}

struct Track: Decodable {
  let artworkUrl: String
  
  enum CodingKeys: String, CodingKey {
    case artworkUrl = "artwork_url"
  }
}

struct Artwork {
  var url: String
  var image: UIImage
}





