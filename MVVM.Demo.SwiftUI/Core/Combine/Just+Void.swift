//
//  Just+Void.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import Combine

extension Just where Output == Void {
  init() {
    self.init(())
  }
}
