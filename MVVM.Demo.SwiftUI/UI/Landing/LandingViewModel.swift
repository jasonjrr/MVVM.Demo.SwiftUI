//
//  LandingViewModel.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import Foundation
import Combine
import SwiftUI

protocol LandingViewModelDelegate: AnyObject {
  func landingViewModelDidTapPulse(_ source: LandingViewModel)
  func landingViewModelDidTapSignIn(_ source: LandingViewModel)
  func landingViewModel(_ source: LandingViewModel, didAlertWith alert: AlertService.Alert)
}

class LandingViewModel: ViewModel {
  private let alertService: AlertServiceProtocol
  private let authenticationService: AuthenticationServiceProtocol
  private let colorService: ColorServiceProtocol
  
  private weak var delegate: LandingViewModelDelegate?
  
  var isAuthenticated: AnyPublisher<Bool, Never> { self.authenticationService.isAuthenticated }
  var username: AnyPublisher<String, Never> {
    self.authenticationService.user.map { $0?.username ?? .empty }.eraseToAnyPublisher()
  }
  let pulseColor: AnyPublisher<Color, Never>
  
  let pulse: PassthroughSubject<Void, Never> = PassthroughSubject()
  let signInOrOut: PassthroughSubject<Void, Never> = PassthroughSubject()
  
  private var cancelBag: CancelBag!
  
  init(alertService: AlertServiceProtocol, authenticationService: AuthenticationServiceProtocol, colorService: ColorServiceProtocol) {
    self.alertService = alertService
    self.authenticationService = authenticationService
    self.colorService = colorService
    
    self.pulseColor = self.colorService.generateColors().share(replay: 1).eraseToAnyPublisher()
  }
  
  func setup(delegate: LandingViewModelDelegate) -> Self {
    self.delegate = delegate
    bind()
    return self
  }
  
  private func bind() {
    self.cancelBag = CancelBag()
    
    let alertService = self.alertService
    let authenticationService = self.authenticationService
    
    self.pulse
      .sink(receiveValue: { [weak self] in
        guard let self = self else { return }
        self.delegate?.landingViewModelDidTapPulse(self)
      })
      .store(in: &self.cancelBag)
    
    self.signInOrOut
      .withLatestFrom(self.isAuthenticated)
      .setFailureType(to: Error.self)
      .flatMapLatest { isAuthenticated -> AnyPublisher<AuthAction, Error> in
        if isAuthenticated {
          return Just()
            .setFailureType(to: Error.self)
            .map {
              .signOut(alert: alertService
                .buildAlert(
                  title: "Sign Out",
                  message: "Are you sure you want to sign out?",
                  primaryButton: .destructive("Yes, sign out", action: { _ = authenticationService.signOut() }),
                  secondaryButton: .cancel())) }
            .eraseToAnyPublisher()
        }
        return Just()
          .setFailureType(to: Error.self)
          .map { .signIn }
          .eraseToAnyPublisher()
      }
      .sink { [weak self] (authAction: AuthAction) in
        guard let self = self else { return }
        switch authAction {
        case .signIn:
          self.delegate?.landingViewModelDidTapSignIn(self)
        case .signOut(let alert):
          self.delegate?.landingViewModel(self, didAlertWith: alert)
        }
      }
      .store(in: &self.cancelBag)
  }
}

extension LandingViewModel {
  enum AuthAction {
    case signIn
    case signOut(alert: AlertService.Alert)
  }
}
