//
//  String+Extensions.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import Foundation

extension String {
  static var empty: String { "" }
  
  static var invisibleCharacter: String { "\u{feff}" }
  static func invisibleCharacters(_ count: Int) -> String {
    guard count > 0 else { return .empty }
    var out: String = .empty
    for _ in 1...count {
      out = out + .invisibleCharacter
    }
    return out
  }
  
  static var nonBeakingSpace: String { "\u{00a0}" }
  static func nonBeakingSpaces(_ count: Int) -> String {
    guard count > 0 else { return .empty }
    var out: String = .empty
    for _ in 1...count {
      out = out + .nonBeakingSpace
    }
    return out
  }
  
  static var space: String { " " }
  static func spaces(_ count: Int) -> String {
    guard count > 0 else { return .empty }
    var out: String = .empty
    for _ in 1...count {
      out = out + .space
    }
    return out
  }
}
