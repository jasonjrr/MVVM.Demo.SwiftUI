//
//  View+Conditionals.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import SwiftUI

extension View {
  @ViewBuilder @inlinable
  func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
  }
  
  @ViewBuilder @inlinable
  func `if`<TrueTransform: View, FalseTransform: View>(_ condition: Bool, if trueTransform: (Self) -> TrueTransform, else falseTransform: (Self) -> FalseTransform) -> some View {
    if condition {
      trueTransform(self)
    } else {
      falseTransform(self)
    }
  }
  
  @ViewBuilder @inlinable
  func ifLet<Element, Transform: View>(_ value: Element?, transform: (Self, Element) -> Transform) -> some View {
    if let value = value {
      transform(self, value)
    } else {
      self
    }
  }
  
  @ViewBuilder @inlinable
  func ifLet<Element, TrueTransform: View, FalseTransform: View>(_ value: Element?, if trueTransform: (Self, Element) -> TrueTransform, else falseTransform: (Self) -> FalseTransform) -> some View {
    if let value = value {
      trueTransform(self, value)
    } else {
      falseTransform(self)
    }
  }
}
