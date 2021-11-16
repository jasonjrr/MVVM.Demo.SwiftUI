//
//  PulseViewModel.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/16/21.
//

import Foundation
import Combine
import SwiftUI

protocol PulseViewModelDelegate: AnyObject {
  
}

class PulseViewModel: ViewModel {
  private let authenticationService: AuthenticationServiceProtocol
  private let colorService: ColorServiceProtocol
  private weak var delegate: PulseViewModelDelegate?
  
  @Published private(set) var colors: [ColorItem] = []
  
  var title: AnyPublisher<String, Never> {
    self.authenticationService.user
      .map {
        if let username = $0?.username {
          return "Welcome, \(username)"
        }
        return "Hello, mysterious stranger"
      }
      .eraseToAnyPublisher()
  }
  
  private var cancelBag: CancelBag!
  
  init(authenticationService: AuthenticationServiceProtocol, colorService: ColorServiceProtocol) {
    self.authenticationService = authenticationService
    self.colorService = colorService
  }
  
  func setup(delegate: PulseViewModelDelegate) -> Self {
    self.delegate = delegate
    bind()
    return self
  }
  
  private func bind() {
    self.cancelBag = CancelBag()
    
    self.colorService.generateColors()
      .receive(on: .main)
      .sink(receiveValue: { [weak self] in
        guard let self = self else { return }
        self.colors.insert(ColorItem(color: $0), at: 0)
        if self.colors.count > 3 {
          let _ = self.colors.popLast()
        }
      })
      .store(in: &self.cancelBag)
  }
}

extension PulseViewModel {
  class ColorItem: ViewModel {
    let id: String = UUID().uuidString
    let color: Color
    @Published var opacity: Double = 0.0
    
    init(color: Color) {
      self.color = color
    }
  }
}
