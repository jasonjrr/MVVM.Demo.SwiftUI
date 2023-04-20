//
//  ButtonTextStyle.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import SwiftUI

struct ButtonTextStyle: TextStyle {
  @ScaledMetric private var fontSize: CGFloat = 18.0
  
  func body(content: Content) -> some View {
    content
      .font(.system(size: self.fontSize, weight: .semibold, design: .rounded))
  }
}

extension TextStyle where Self == ButtonTextStyle {
  static var button: Self {
    ButtonTextStyle()
  }
}
