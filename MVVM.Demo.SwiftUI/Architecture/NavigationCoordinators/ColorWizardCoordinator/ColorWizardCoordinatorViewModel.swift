//
//  ColorWizardCoordinatorViewModel.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/17/21.
//

import Foundation
import Swinject

@Observable @MainActor
final class ColorWizardCoordinatorViewModel: ViewModel {
  @ObservationIgnored private let resolver: Resolver
  
  @ObservationIgnored private weak var delegate: Delegate?
  @ObservationIgnored private var configurationViewModel: ColorWizardConfigurationViewModel!
  
  let path: CoordinatorNavigationPath = CoordinatorNavigationPath()
  
  private(set) var rootContentViewModel: ColorWizardContentViewModel!
  
  init(resolver: Resolver) {
    self.resolver = resolver
  }
  
  @discardableResult
  func setup(configuration: ColorWizardConfiguration, delegate: Delegate) -> Self {
    self.delegate = delegate
    self.configurationViewModel = ColorWizardConfigurationViewModel(configuration: configuration)
  
    if let firstPageViewModel = self.configurationViewModel.pages.first {
      self.rootContentViewModel = self.resolver.resolved(ColorWizardContentViewModel.self)
        .setup(pageViewModel: firstPageViewModel, delegate: self)
    } else {
      fatalError()
    }
    
    return self
  }
}

extension ColorWizardCoordinatorViewModel {
  @MainActor protocol Delegate: AnyObject {
    func colorWizardCoordinatorViewModelDidComplete(_ source: ColorWizardCoordinatorViewModel)
  }
}

// MARK: ColorWizardContentViewModel.Delegate
extension ColorWizardCoordinatorViewModel: ColorWizardContentViewModel.Delegate {
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
    
    self.path.append(self.resolver.resolved(ColorWizardContentViewModel.self)
      .setup(pageViewModel: nextPageViewModel, delegate: self))
  }
  
  func colorWizardContentViewModel(_ source: ColorWizardContentViewModel, didCompleteFromIndex index: Int) {
    self.delegate?.colorWizardCoordinatorViewModelDidComplete(self)
  }
}
