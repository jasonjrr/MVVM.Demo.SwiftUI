//
//  CardView.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import SwiftUI

struct CardView<Content>: View where Content: View {
  let alignment: Alignment
  let color: Color
  let cornerRadius: CornerRadius
  let content: Content
  
  init(
    alignment: Alignment = .topLeading,
    color: Color,
    cornerRadius: CornerRadius = .medium,
    @ViewBuilder content: () -> Content) {
      self.alignment = alignment
      self.color = color
      self.cornerRadius = cornerRadius
      self.content = content()
    }
  
  var body: some View {
    ZStack(alignment: self.alignment) {
      RoundedRectangle(cornerRadius: self.cornerRadius.value, style: .continuous)
        .fill(self.color)
      self.content
    }
  }
}

extension CardView {
  enum CornerRadius {
    case small
    case medium
    case large
    case custom(CGFloat)
    
    var value: CGFloat {
      switch self {
      case .small: return 4.0
      case .medium: return 8.0
      case .large: return 16.0
      case .custom(let value): return value
      }
    }
  }
}

struct CardView_Previews: PreviewProvider {
  static var previews: some View {
    return CardView(
      color: Color.green,
      cornerRadius: .medium) {
        Text("Card contents.")
          .padding()
          .background(Color.orange)
      }
      .clipped()
      .shadow(radius: 10)
      .padding()
  }
}
