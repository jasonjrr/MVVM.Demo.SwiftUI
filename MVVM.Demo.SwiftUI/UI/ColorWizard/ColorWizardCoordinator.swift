//
//  ColorWizardCoordinator.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/17/21.
//

import Foundation
import Combine
import Swinject

protocol ColorWizardCoordinatorDelegate: AnyObject {
  func colorWizardCoordinatorDidComplete(_ source: ColorWizardCoordinator)
}

class ColorWizardCoordinator: ViewModel {
  private let resolver: Resolver
  
  private weak var delegate: ColorWizardCoordinatorDelegate?
  private var configurationViewModel: ColorWizardConfigurationViewModel!
  
  @Published var colorWizardPageCoordinator: ColorWizardPageCoordinator!
  
  init(resolver: Resolver) {
    self.resolver = resolver
  }
  
  func setup(configuration: ColorWizardConfiguration, delegate: ColorWizardCoordinatorDelegate) -> Self {
    self.delegate = delegate
    self.configurationViewModel = ColorWizardConfigurationViewModel(configuration: configuration)
  
    if let firstPageViewModel = self.configurationViewModel.pages.first {
      self.colorWizardPageCoordinator = self.resolver.resolve(ColorWizardPageCoordinator.self)!
        .setup(currentPageViewModel: firstPageViewModel, delegate: self)
    } else {
      fatalError()
    }
    
    return self
  }
}

// MARK: ColorWizardPageCoordinatorDelegate
extension ColorWizardCoordinator: ColorWizardPageCoordinatorDelegate {
  func colorWizardPageCoordinator(_ source: ColorWizardPageCoordinator, canMoveBackFromIndex index: Int) -> Bool {
    return index != 0
  }
  
  func colorWizardPageCoordinator(_ source: ColorWizardPageCoordinator, canMoveForwardFromIndex index: Int) -> Bool {
    return self.configurationViewModel.pages.count > index + 1
  }
  
  func colorWizardPageCoordinator(_ source: ColorWizardPageCoordinator, canCompleteFromIndex index: Int) -> Bool {
    return self.configurationViewModel.pages.count == index + 1
  }
  
  func colorWizardPageCoordinator(_ source: ColorWizardPageCoordinator, didMoveBackFromIndex index: Int) {
    fatalError("A back command should never reach this coordinator.")
  }
  
  func colorWizardPageCoordinator(_ source: ColorWizardPageCoordinator, nextPageAfterIndex index: Int) -> ColorWizardConfigurationViewModel.PageViewModel? {
    let newIndex = index + 1
    guard newIndex < self.configurationViewModel.pages.count else {
      return nil
    }
    return self.configurationViewModel.pages[newIndex]
  }
  
  func colorWizardPageCoordinator(_ source: ColorWizardPageCoordinator, didCompleteFromIndex index: Int) {
    self.delegate?.colorWizardCoordinatorDidComplete(self)
  }
}
