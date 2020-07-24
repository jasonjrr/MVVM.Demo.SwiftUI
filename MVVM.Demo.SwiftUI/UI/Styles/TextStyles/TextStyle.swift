//
//  TextStyle.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import SwiftUI

protocol TextStyle: ViewModifier {}

extension Text {
  func textStyle<Style: TextStyle>(_ style: Style) -> some View {
    ModifiedContent(content: self, modifier: style)
  }
}

extension View {
  func textStyle<Style: TextStyle>(_ style: Style) -> some View {
    ModifiedContent(content: self, modifier: style)
  }
}
