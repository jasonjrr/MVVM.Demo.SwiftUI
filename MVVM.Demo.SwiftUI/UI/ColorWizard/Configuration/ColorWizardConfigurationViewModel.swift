//
//  ColorWizardConfigurationViewModel.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/17/21.
//

import Foundation
import Combine
import SwiftUI

@Observable
class ColorWizardConfigurationViewModel: ViewModel {
  let pages: [PageViewModel]
  
  init(configuration: ColorWizardConfiguration) {
    var pageViewModels: [PageViewModel] = []
    for (index, page) in configuration.pages.enumerated() {
      pageViewModels.append(PageViewModel(page: page, index: index))
    }
    self.pages = pageViewModels
  }
}

extension ColorWizardConfigurationViewModel {
  @Observable
  class PageViewModel: ViewModel {
    let index: Int
    let title: String
    let color: Color?
    let colors: [ColorViewModel]
    
    init(page: ColorWizardConfiguration.Page, index: Int) {
      self.index = index
      self.title = page.title
      self.color = page.color
      self.colors = page.colors.map { ColorViewModel(color: $0) }
    }
  }
  
  @Observable
  class ColorViewModel: ViewModel {
    let id: String = UUID().uuidString
    let color: Color
    
    init(color: Color) {
      self.color = color
    }
  }
}
