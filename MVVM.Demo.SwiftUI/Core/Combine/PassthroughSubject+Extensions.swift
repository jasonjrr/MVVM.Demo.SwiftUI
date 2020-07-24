//
//  PassthroughSubject+Extensions.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import Combine

extension PassthroughSubject where Output == Void {
  func send() {
    self.send(())
  }
}
