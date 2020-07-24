//
//  EdgeInsets+Extensions.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import SwiftUI

extension EdgeInsets {
  init(all: CGFloat) {
    self.init(top: all, leading: all, bottom: all, trailing: all)
  }
  
  init(horizontal: CGFloat, vertical: CGFloat) {
    self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
  }
  
  init(top: CGFloat, and remaining: CGFloat) {
    self.init(top: top, leading: remaining, bottom: remaining, trailing: remaining)
  }
  
  static func all(_ value: CGFloat) -> EdgeInsets {
    EdgeInsets(all: value)
  }
  
  static func horizontal(_ horizontal: CGFloat, vertical: CGFloat) -> EdgeInsets {
    EdgeInsets(horizontal: horizontal, vertical: vertical)
  }
  
  static func top(_ top: CGFloat, and remaining: CGFloat) -> EdgeInsets {
    EdgeInsets(top: top, and: remaining)
  }
}
