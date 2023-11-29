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
  var colorWizardCoordinator: ColorWizardCoordinator?
  
  init(resolver: Resolver) {
    self.resolver = resolver
    
    self.landingViewModel = self.resolver.resolve(LandingViewModel.self)!
      .setup(delegate: self)
  }
}

// MARK: LandingViewModelDelegate
extension AppRootCoordinator: LandingViewModelDelegate {
  func landingViewModelDidTapPulse(_ source: LandingViewModel) {
    self.path.append(self.resolver.resolve(PulseViewModel.self)!
      .setup(delegate: self))
  }
  
  func landingViewModelDidTapSignIn(_ source: LandingViewModel) {
    self.signInViewModel = self.resolver.resolve(SignInViewModel.self)!
      .setup(delegate: self)
  }
  
  func landingViewModelDidTapColorWizard(_ source: LandingViewModel) {
    self.colorWizardCoordinator = self.resolver.resolve(ColorWizardCoordinator.self)!
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

// MARK: ColorWizardCoordinatorDelegate
extension AppRootCoordinator: ColorWizardCoordinatorDelegate {
  func colorWizardCoordinatorDidComplete(_ source: ColorWizardCoordinator) {
    self.colorWizardCoordinator = nil
  }
}
