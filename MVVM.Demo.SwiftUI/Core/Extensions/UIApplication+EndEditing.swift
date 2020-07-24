//
//  UIApplication+EndEditing.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import UIKit
import SwiftUI

extension UIApplication {
  func endEditing() {
    sendAction(
      #selector(UIResponder.resignFirstResponder),
      to: nil,
      from: nil,
      for: nil)
  }
}

extension View {
  func endEditing() {
    UIApplication.shared.endEditing()
  }
}

extension ViewModel {
  func endEditing() {
    UIApplication.shared.endEditing()
  }
}
