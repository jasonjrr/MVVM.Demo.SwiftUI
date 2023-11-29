//
//  ColorWizardContentViewModel.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/17/21.
//

import Foundation
import SwiftUI

protocol ColorWizardContentViewModelDelegate: AnyObject {
  func colorWizardContentViewModel(_ source: ColorWizardContentViewModel, canMoveBackFromIndex index: Int) -> Bool
  func colorWizardContentViewModel(_ source: ColorWizardContentViewModel, canMoveForwardFromIndex index: Int) -> Bool
  func colorWizardContentViewModel(_ source: ColorWizardContentViewModel, canCompleteFromIndex index: Int) -> Bool
  
  func colorWizardContentViewModel(_ source: ColorWizardContentViewModel, didMoveBackFromIndex index: Int)
  func colorWizardContentViewModel(_ source: ColorWizardContentViewModel, didMoveForwardFromIndex index: Int)
  func colorWizardContentViewModel(_ source: ColorWizardContentViewModel, didCompleteFromIndex index: Int)
}

@Observable
class ColorWizardContentViewModel: ViewModel {
  private var pageViewModel: ColorWizardConfigurationViewModel.PageViewModel!
  private weak var delegate: ColorWizardContentViewModelDelegate?
  
  var index: Int { self.pageViewModel.index }
  var title: String { self.pageViewModel.title }
  var color: Color? { self.pageViewModel.color }
  var colors: [ColorWizardConfigurationViewModel.ColorViewModel] { self.pageViewModel.colors }
  
  var canMoveBack: Bool {
    self.delegate?.colorWizardContentViewModel(self, canMoveBackFromIndex: self.index) ?? false
  }
  
  var canMoveForward: Bool {
    self.delegate?.colorWizardContentViewModel(self, canMoveForwardFromIndex: self.index) ?? false
  }
  
  var canComplete: Bool {
    self.delegate?.colorWizardContentViewModel(self, canCompleteFromIndex: self.index) ?? false
  }
  
  @discardableResult
  func setup(pageViewModel: ColorWizardConfigurationViewModel.PageViewModel, delegate: ColorWizardContentViewModelDelegate?) -> Self {
    self.pageViewModel = pageViewModel
    self.delegate = delegate
    return self
  }
  
  func moveBack() {
    self.delegate?.colorWizardContentViewModel(self, didMoveBackFromIndex: self.index)
  }
  
  func moveForward() {
    self.delegate?.colorWizardContentViewModel(self, didMoveForwardFromIndex: self.index)
  }
  
  func complete() {
    self.delegate?.colorWizardContentViewModel(self, didCompleteFromIndex: self.index)
  }
}
