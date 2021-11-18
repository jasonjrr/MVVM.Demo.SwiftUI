//
//  ColorWizardConfiguration.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/17/21.
//

import SwiftUI

struct ColorWizardConfiguration {
  let pages: [Page]
}

extension ColorWizardConfiguration {
  struct Page {
    let title: String
    let color: Color?
    let colors: [Color]
    
    static func page(_ title: String, color: Color? = nil, colors: [Color] = []) -> Page {
      Page(title: title, color: color, colors: colors)
    }
  }
}
