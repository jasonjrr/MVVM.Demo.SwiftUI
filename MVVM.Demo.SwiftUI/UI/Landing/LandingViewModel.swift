//
//  LandingViewModel.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import Foundation
import Combine

@Observable @MainActor
final class LandingViewModel: ViewModel {
  @ObservationIgnored private let alertService: AlertServiceProtocol
  @ObservationIgnored private let authenticationService: AuthenticationServiceProtocol
  @ObservationIgnored private let colorService: ColorServiceProtocol
  
  @ObservationIgnored private weak var delegate: Delegate?
  
  private(set) var isAuthenticated: Bool = false
  private(set) var username: String = .empty
  private(set) var pulseColor: ColorModel?
  
  @ObservationIgnored private var cancelBag: CancelBag = CancelBag()
  
  init(alertService: AlertServiceProtocol, authenticationService: AuthenticationServiceProtocol, colorService: ColorServiceProtocol) {
    self.alertService = alertService
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
    
    self.authenticationService.isAuthenticated
      .receive(on: RunLoop.main)
      .sink { [weak self] isAuthenticated in
        self?.isAuthenticated = isAuthenticated
      }
      .store(in: &self.cancelBag)
    
    self.authenticationService.user
      .map { $0?.username ?? .empty }
      .receive(on: RunLoop.main)
      .sink { [weak self] username in
        self?.username = username
      }
      .store(in: &self.cancelBag)
    
    self.colorService.generateColors()
      .receive(on: RunLoop.main)
      .sink { [weak self] color in
        self?.pulseColor = color
      }
      .store(in: &self.cancelBag)
  }
  
  func pulse() {
    self.delegate?.landingViewModelDidTapPulse(self)
  }
  
  func signInOrOut() {
    if self.isAuthenticated {
      let authenticationService = self.authenticationService
      self.alertService.present(
        title: "Sign Out",
        message: "Are you sure you want to sign out?",
        primaryButton: .destructive("Yes, sign out") {
          authenticationService.signOutAsync()
        },
        secondaryButton: .cancel())
    } else {
      self.delegate?.landingViewModelDidTapSignIn(self)
    }
  }
  
  func infiniteCards() {
    self.delegate?.landingViewModelDidTapInfiniteCards(self)
  }
  
  func colorWizard() {
    self.delegate?.landingViewModelDidTapColorWizard(self)
  }
}

extension LandingViewModel {
  @MainActor protocol Delegate: AnyObject {
    func landingViewModelDidTapPulse(_ source: LandingViewModel)
    func landingViewModelDidTapSignIn(_ source: LandingViewModel)
    func landingViewModelDidTapInfiniteCards(_ source: LandingViewModel)
    func landingViewModelDidTapColorWizard(_ source: LandingViewModel)
  }
}
