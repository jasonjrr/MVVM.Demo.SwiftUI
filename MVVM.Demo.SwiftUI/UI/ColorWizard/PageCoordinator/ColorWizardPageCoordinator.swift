//
//  ColorWizardPageCoordinator.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/17/21.
//

import Foundation
import Combine
import Swinject

protocol ColorWizardPageCoordinatorDelegate: AnyObject {
  func colorWizardPageCoordinator(_ source: ColorWizardPageCoordinator, canMoveBackFromIndex index: Int) -> Bool
  func colorWizardPageCoordinator(_ source: ColorWizardPageCoordinator, canMoveForwardFromIndex index: Int) -> Bool
  func colorWizardPageCoordinator(_ source: ColorWizardPageCoordinator, canCompleteFromIndex index: Int) -> Bool
  
  func colorWizardPageCoordinator(_ source: ColorWizardPageCoordinator, didMoveBackFromIndex index: Int)
  func colorWizardPageCoordinator(_ source: ColorWizardPageCoordinator, nextPageAfterIndex index: Int) -> ColorWizardConfigurationViewModel.PageViewModel?
  func colorWizardPageCoordinator(_ source: ColorWizardPageCoordinator, didCompleteFromIndex index: Int)
}

class ColorWizardPageCoordinator: ViewModel {
  private let resolver: Resolver
  
  private weak var delegate: ColorWizardPageCoordinatorDelegate?
  
  @Published var contentViewModel: ColorWizardContentViewModel!
  @Published var nextPageCoordinator: ColorWizardPageCoordinator?
  
  init(resolver: Resolver) {
    self.resolver = resolver
  }
  
  func setup(currentPageViewModel: ColorWizardConfigurationViewModel.PageViewModel, delegate: ColorWizardPageCoordinatorDelegate) -> Self {
    self.delegate = delegate
    
    self.contentViewModel = self.resolver.resolve(ColorWizardContentViewModel.self)!
      .setup(pageViewModel: currentPageViewModel, delegate: self)
    
    return self
  }
}

// MARK: ColorWizardPageCoordinatorDelegate
extension ColorWizardPageCoordinator: ColorWizardPageCoordinatorDelegate {
  func colorWizardPageCoordinator(_ source: ColorWizardPageCoordinator, canMoveBackFromIndex index: Int) -> Bool {
    self.delegate?.colorWizardPageCoordinator(self, canMoveBackFromIndex: index) ?? false
  }
  
  func colorWizardPageCoordinator(_ source: ColorWizardPageCoordinator, canMoveForwardFromIndex index: Int) -> Bool {
    self.delegate?.colorWizardPageCoordinator(self, canMoveForwardFromIndex: index) ?? false
  }
  
  func colorWizardPageCoordinator(_ source: ColorWizardPageCoordinator, canCompleteFromIndex index: Int) -> Bool {
    self.delegate?.colorWizardPageCoordinator(self, canCompleteFromIndex: index) ?? false
  }
  
  func colorWizardPageCoordinator(_ source: ColorWizardPageCoordinator, didMoveBackFromIndex index: Int) {
    if self.contentViewModel.index < index {
      self.nextPageCoordinator = nil
    } else {
      self.delegate?.colorWizardPageCoordinator(self, didMoveBackFromIndex: index)
    }
  }
  
  func colorWizardPageCoordinator(_ source: ColorWizardPageCoordinator, nextPageAfterIndex index: Int) -> ColorWizardConfigurationViewModel.PageViewModel? {
    self.delegate?.colorWizardPageCoordinator(self, nextPageAfterIndex: index)
  }
  
  func colorWizardPageCoordinator(_ source: ColorWizardPageCoordinator, didCompleteFromIndex index: Int) {
    self.delegate?.colorWizardPageCoordinator(self, didCompleteFromIndex: index)
  }
}

// MARK: ColorWizardContentViewModelDelegate
extension ColorWizardPageCoordinator: ColorWizardContentViewModelDelegate {
  func colorWizardContentViewModel(_ source: ColorWizardContentViewModel, canMoveBackFromIndex index: Int) -> Bool {
    self.delegate?.colorWizardPageCoordinator(self, canMoveBackFromIndex: index) ?? false
  }
  
  func colorWizardContentViewModel(_ source: ColorWizardContentViewModel, canMoveForwardFromIndex index: Int) -> Bool {
    self.delegate?.colorWizardPageCoordinator(self, canMoveForwardFromIndex: index) ?? false
  }
  
  func colorWizardContentViewModel(_ source: ColorWizardContentViewModel, canCompleteFromIndex index: Int) -> Bool {
    self.delegate?.colorWizardPageCoordinator(self, canCompleteFromIndex: index) ?? false
  }
  
  func colorWizardContentViewModel(_ source: ColorWizardContentViewModel, didMoveBackFromIndex index: Int) {
    self.delegate?.colorWizardPageCoordinator(self, didMoveBackFromIndex: index)
  }
  
  func colorWizardContentViewModel(_ source: ColorWizardContentViewModel, didMoveForwardFromIndex index: Int) {
    guard let nextPageViewModel = self.delegate?.colorWizardPageCoordinator(self, nextPageAfterIndex: index) else {
      fatalError()
    }
    self.nextPageCoordinator = self.resolver.resolve(ColorWizardPageCoordinator.self)!
      .setup(currentPageViewModel: nextPageViewModel, delegate: self)
  }
  
  func colorWizardContentViewModel(_ source: ColorWizardContentViewModel, didCompleteFromIndex index: Int) {
    self.delegate?.colorWizardPageCoordinator(self, didCompleteFromIndex: index)
  }
}
