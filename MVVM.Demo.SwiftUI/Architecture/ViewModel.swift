//
//  ViewModel.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import Foundation

typealias ViewModelDefinition = (AnyObject & Identifiable & Hashable & HapticFeedbackProvider)

protocol ViewModel: ViewModelDefinition {}

extension ViewModel {
  static func ==(lhs: Self, rhs: Self) -> Bool {
    lhs === rhs
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
  }
}
