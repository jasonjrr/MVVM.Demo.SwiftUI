//
//  TextStyle.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import SwiftUI

protocol TextStyle: ViewModifier {}

extension View {
  func textStyle<Style: TextStyle>(_ style: Style) -> some View {
    ModifiedContent(content: self, modifier: style)
  }
}
