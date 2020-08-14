#  MemoryGame

## Summary
A simple 4x4 grid memory game. Initially cards shown “face down“. After tapping on card it flips and image will be shown. If two flipped cards images match, images remain open, otherwise cards flip back. Game continues until all matches will be found.


### Requirements

- iOS 11.0+
- Xcode 9.2+
- Swift 4.0+


### Installing

Project does not use any third party dependency manager.  Open project file and simply run
**baseURL** - before running project provide baseURL in ```NetworkRequest``` extension
**ClientID** - before running project provide clientID in ```NetworkRequest``` extension


### Application

Application is written in Swift. It Follows simplified VIPER + ViewModel paradigm. Because of one view simplicity there is no Router to manage app flow. The main dependency - the grid size, is set in ViewController.


### Testing

Tests are written using XCTTest. Game logic is covered with unit tests
To run tests use ```CMD + U```
