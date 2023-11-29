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

@Observable
class ColorWizardCoordinator: ViewModel {
  private let resolver: Resolver
  
  private weak var delegate: ColorWizardCoordinatorDelegate?
  private var configurationViewModel: ColorWizardConfigurationViewModel!
  
  let path = ObjectNavigationPath()
  
  private(set) var rootContentViewModel: ColorWizardContentViewModel!
  
  init(resolver: Resolver) {
    self.resolver = resolver
  }
  
  func setup(configuration: ColorWizardConfiguration, delegate: ColorWizardCoordinatorDelegate) -> Self {
    self.delegate = delegate
    self.configurationViewModel = ColorWizardConfigurationViewModel(configuration: configuration)
  
    if let firstPageViewModel = self.configurationViewModel.pages.first {
      self.rootContentViewModel = self.resolver.resolve(ColorWizardContentViewModel.self)!
        .setup(pageViewModel: firstPageViewModel, delegate: self)
    } else {
      fatalError()
    }
    
    return self
  }
}

// MARK: ColorWizardContentViewModelDelegate
extension ColorWizardCoordinator: ColorWizardContentViewModelDelegate {
  func colorWizardContentViewModel(_ source: ColorWizardContentViewModel, canMoveBackFromIndex index: Int) -> Bool {
    return index != 0
  }
  
  func colorWizardContentViewModel(_ source: ColorWizardContentViewModel, canMoveForwardFromIndex index: Int) -> Bool {
    return self.configurationViewModel.pages.count > index + 1
  }
  
  func colorWizardContentViewModel(_ source: ColorWizardContentViewModel, canCompleteFromIndex index: Int) -> Bool {
    return self.configurationViewModel.pages.count == index + 1
  }
  
  func colorWizardContentViewModel(_ source: ColorWizardContentViewModel, didMoveBackFromIndex index: Int) {
    self.path.removeLast(through: source)
  }
  
  func colorWizardContentViewModel(_ source: ColorWizardContentViewModel, didMoveForwardFromIndex index: Int) {
    let newIndex = index + 1
    guard newIndex < self.configurationViewModel.pages.count else {
      fatalError()
    }
    let nextPageViewModel = self.configurationViewModel.pages[newIndex]
    
    self.path.append(self.resolver.resolve(ColorWizardContentViewModel.self)!
      .setup(pageViewModel: nextPageViewModel, delegate: self))
  }
  
  func colorWizardContentViewModel(_ source: ColorWizardContentViewModel, didCompleteFromIndex index: Int) {
    self.delegate?.colorWizardCoordinatorDidComplete(self)
  }
}
