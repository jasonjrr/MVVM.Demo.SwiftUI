//
//  Button+Extensions.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import SwiftUI
import Combine

extension Button {
  init(action: PassthroughSubject<Void, Never>, @ViewBuilder label: () -> Label) {
    self.init(action: { action.send() }, label: label)
  }
}
