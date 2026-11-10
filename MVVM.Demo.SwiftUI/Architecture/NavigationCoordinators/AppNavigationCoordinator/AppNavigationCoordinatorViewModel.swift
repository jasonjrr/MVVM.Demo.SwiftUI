//
//  AppNavigationCoordinatorViewModel.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import Foundation
import Swinject

@Observable @MainActor
final class AppNavigationCoordinatorViewModel: ViewModel {
  @ObservationIgnored private let resolver: Resolver
  
  let landingViewModel: LandingViewModel
  let path: CoordinatorNavigationPath = CoordinatorNavigationPath()
  
  var signInViewModel: SignInViewModel?
  var infiniteCardsViewModel: InfiniteCardsViewModel?
  var colorWizardCoordinatorViewModel: ColorWizardCoordinatorViewModel?
  
  init(resolver: Resolver) {
    self.resolver = resolver
    self.landingViewModel = resolver.resolved(LandingViewModel.self)
    self.landingViewModel.setup(delegate: self)
  }
}

// MARK: LandingViewModel.Delegate
extension AppNavigationCoordinatorViewModel: LandingViewModel.Delegate {
  func landingViewModelDidTapPulse(_ source: LandingViewModel) {
    self.path.append(self.resolver.resolved(PulseViewModel.self)
      .setup(delegate: self))
  }
  
  func landingViewModelDidTapSignIn(_ source: LandingViewModel) {
    self.signInViewModel = self.resolver.resolved(SignInViewModel.self)
      .setup(delegate: self)
  }
  
  func landingViewModelDidTapInfiniteCards(_ source: LandingViewModel) {
    self.infiniteCardsViewModel = self.resolver.resolved(InfiniteCardsViewModel.self)
      .setup(delegate: self)
  }
  
  func landingViewModelDidTapColorWizard(_ source: LandingViewModel) {
    self.colorWizardCoordinatorViewModel = self.resolver.resolved(ColorWizardCoordinatorViewModel.self)
      .setup(configuration: ColorWizardConfiguration.mock(), delegate: self)
  }
}

// MARK: SignInViewModel.Delegate
extension AppNavigationCoordinatorViewModel: SignInViewModel.Delegate {
  func signInViewModelDidCancel(_ source: SignInViewModel) {
    self.signInViewModel = nil
  }
  
  func signInViewModelDidSignIn(_ source: SignInViewModel) {
    self.signInViewModel = nil
  }
}

// MARK: PulseViewModel.Delegate
extension AppNavigationCoordinatorViewModel: PulseViewModel.Delegate {
  // Nothing yet
}

// MARK: InfiniteCardsViewModel.Delegate
extension AppNavigationCoordinatorViewModel: InfiniteCardsViewModel.Delegate {
  func infiniteCardsViewModelDidClose(_ sender: InfiniteCardsViewModel) {
    self.infiniteCardsViewModel = nil
  }
}

// MARK: ColorWizardCoordinatorViewModel.Delegate
extension AppNavigationCoordinatorViewModel: ColorWizardCoordinatorViewModel.Delegate {
  func colorWizardCoordinatorViewModelDidComplete(_ source: ColorWizardCoordinatorViewModel) {
    self.colorWizardCoordinatorViewModel = nil
  }
}
