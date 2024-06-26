//
//  AppRootCoordinator.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import Foundation
import Combine
import Swinject

@Observable
class AppRootCoordinator: ViewModel {
  private let resolver: Resolver
  
  private(set) var landingViewModel: LandingViewModel!
  
  let path = ObjectNavigationPath()
  
  var signInViewModel: SignInViewModel?
  var infiniteCardsViewModel: InfiniteCardsViewModel?
  var colorWizardCoordinator: ColorWizardCoordinator?
  
  init(resolver: Resolver) {
    self.resolver = resolver
    
    self.landingViewModel = self.resolver.resolved(LandingViewModel.self)
      .setup(delegate: self)
  }
}

// MARK: LandingViewModelDelegate
extension AppRootCoordinator: LandingViewModelDelegate {
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
    self.colorWizardCoordinator = self.resolver.resolved(ColorWizardCoordinator.self)
      .setup(configuration: ColorWizardConfiguration.mock(), delegate: self)
  }
}

// MARK: SignInViewModelDelegate
extension AppRootCoordinator: SignInViewModelDelegate {
  func signInViewModelDidCancel(_ source: SignInViewModel) {
    self.signInViewModel = nil
  }
  
  func signInViewModelDidSignIn(_ source: SignInViewModel) {
    self.signInViewModel = nil
  }
}

// MARK: PulseViewModelDelegate
extension AppRootCoordinator: PulseViewModelDelegate {
  // Nothing yet
}

// MARK: InfiniteCardsViewModelDelegate
extension AppRootCoordinator: InfiniteCardsViewModel.Delegate {
  func infiniteCardsViewModelDidClose(_ sender: InfiniteCardsViewModel) {
    self.infiniteCardsViewModel = nil
  }
}

// MARK: ColorWizardCoordinatorDelegate
extension AppRootCoordinator: ColorWizardCoordinatorDelegate {
  func colorWizardCoordinatorDidComplete(_ source: ColorWizardCoordinator) {
    self.colorWizardCoordinator = nil
  }
}
