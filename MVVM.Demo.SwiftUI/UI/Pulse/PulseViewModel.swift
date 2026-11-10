//
//  PulseViewModel.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/16/21.
//

import Foundation
import Combine
import SwiftUI

@Observable @MainActor
final class PulseViewModel: ViewModel {
  @ObservationIgnored private let authenticationService: AuthenticationServiceProtocol
  @ObservationIgnored private let colorService: ColorServiceProtocol
  @ObservationIgnored private weak var delegate: Delegate?
  
  private(set) var colors: [ColorItem] = []
  private(set) var title: String = "Hello, mysterious stranger"
  
  @ObservationIgnored private var cancelBag: CancelBag = CancelBag()
  
  init(authenticationService: AuthenticationServiceProtocol, colorService: ColorServiceProtocol) {
    self.authenticationService = authenticationService
    self.colorService = colorService
  }
  
  @discardableResult
  func setup(delegate: Delegate) -> Self {
    self.delegate = delegate
    bind()
    return self
  }
  
  private func bind() {
    self.cancelBag = CancelBag()
    
    self.authenticationService.user
      .map {
        if let username = $0?.username {
          return "Welcome, \(username)"
        }
        return "Hello, mysterious stranger"
      }
      .receive(on: RunLoop.main)
      .sink { [weak self] title in
        self?.title = title
      }
      .store(in: &self.cancelBag)
    
    self.colorService.generateColors()
      .receive(on: RunLoop.main)
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
  @MainActor protocol Delegate: AnyObject {}
}

extension PulseViewModel {
  @Observable @MainActor
  final class ColorItem: ViewModel {
    let id: String = UUID().uuidString
    let color: Color
    var opacity: Double = 0.0
    
    init(color model: ColorModel) {
      switch model {
      case .blue: self.color = .blue
      case .green: self.color = .green
      case .orange: self.color = .orange
      case .pink: self.color = .pink
      case .purple: self.color = .purple
      case .red: self.color = .red
      case .white: self.color = .white
      case .yellow: self.color = .yellow
      }
    }
  }
}
