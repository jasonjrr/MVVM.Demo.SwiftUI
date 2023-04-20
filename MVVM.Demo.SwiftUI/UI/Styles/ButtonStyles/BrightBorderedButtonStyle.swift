//
//  BrightBorderedButtonStyle.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import SwiftUI

struct BrightBorderedButtonStyle: ButtonStyle {
  let color: Color
  let cornerRadius: CGFloat
  let borderWidth: CGFloat
  
  init(color: Color = .accentColor, cornerRadius: CGFloat = 16.0, borderWidth: CGFloat = 2.0) {
    self.color = color
    self.cornerRadius = cornerRadius
    self.borderWidth = borderWidth
  }

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .foregroundColor(.white)
      .colorMultiply(self.color)
      .textStyle(.button)
      .overlay(
        RoundedRectangle(cornerRadius: self.cornerRadius, style: .continuous)
          .stroke(self.color, lineWidth: self.borderWidth)
          .padding(1.0)
      )
      .opacity(configuration.isPressed ? 0.5 : 1.0)
  }
}

extension ButtonStyle where Self == BrightBorderedButtonStyle {
  static var brightBorderedButton: BrightBorderedButtonStyle {
    BrightBorderedButtonStyle()
  }
  
  static func brightBorderedButton(color: Color = .accentColor, cornerRadius: CGFloat = 16.0, borderWidth: CGFloat = 2.0) -> BrightBorderedButtonStyle {
    BrightBorderedButtonStyle(color: color, cornerRadius: cornerRadius, borderWidth: borderWidth)
  }
}
