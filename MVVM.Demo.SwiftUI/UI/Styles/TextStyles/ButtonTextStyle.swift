//
//  ButtonTextStyle.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import SwiftUI

struct ButtonTextStyle: TextStyle {
  func body(content: Content) -> some View {
    content
      .font(.system(size: 18.0, weight: .semibold, design: .rounded))
  }
}

extension TextStyle where Self == ButtonTextStyle {
  static var button: Self {
    ButtonTextStyle()
  }
}
