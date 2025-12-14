# How to test/build/run
  
Clone the project and run with xCode 26.1

# Architecture decisions

The architecture used is MVVM, it was my first time building from scratch a MVVM with SwiftUI.
Unfortunately I did not have enough time to improve changes, but here's my todo list for my future self.

### For the future (TODO)

- Improve and clean GamePlayViewModel
  - Remove animation
  - Remove SwiftUI import
  - Split with protocols what should be exposed for views(ChessSquareView, GameStatsView, ChessBoardView)
- General clean in views
  - Create own view models if needed
  - Retrieve and create separated files for AssistingViews
- Re-adapt the tests after changes
  
