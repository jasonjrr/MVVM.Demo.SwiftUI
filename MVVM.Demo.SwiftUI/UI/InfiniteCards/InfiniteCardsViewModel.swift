//
//  InfiniteCardsViewModel.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 4/29/24.
//

import Foundation

@Observable
class InfiniteCardsViewModel: ViewModel {
  private let colorService: ColorServiceProtocol
  
  private weak var delegate: InfiniteCardsViewModel.Delegate?
  
  private(set) var cards: [CardViewModel] = []
  
  init(colorService: ColorServiceProtocol) {
    self.colorService = colorService
    fetchNextBatch()
  }
  
  func setup(delegate: InfiniteCardsViewModel.Delegate) -> Self {
    self.delegate = delegate
    return self
  }
  
  func close() {
    self.delegate?.infiniteCardsViewModelDidClose(self)
  }
  
  func fetchNextBatch(currentCardViewModel: CardViewModel? = nil) {
    currentCardViewModel?.shouldFetchNextBatch = false
    
    var cards: [CardViewModel] = Array(self.cards)
    for i in 0..<5 {
      cards.append(CardViewModel(
        colorModel: self.colorService.getNextColor(),
        shouldFetchNextBatch: i == 3))
    }
    self.cards = cards
  }
}

extension InfiniteCardsViewModel {
  protocol Delegate: AnyObject {
    func infiniteCardsViewModelDidClose(_ sender: InfiniteCardsViewModel)
  }
}

extension InfiniteCardsViewModel {
  @Observable
  class CardViewModel: Identifiable {
    let id = UUID()
    let colorModel: ColorModel
    var shouldFetchNextBatch: Bool
    
    init(colorModel: ColorModel, shouldFetchNextBatch: Bool) {
      self.colorModel = colorModel
      self.shouldFetchNextBatch = shouldFetchNextBatch
    }
  }
}
