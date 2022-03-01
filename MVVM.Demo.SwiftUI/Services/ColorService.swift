//
//  ColorService.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import Foundation
import SwiftUI
import Combine

protocol ColorServiceProtocol: AnyObject {
  func getNextColor() -> Color
  func generateColors(runLoop: RunLoop) -> AnyPublisher<Color, Never>
}

extension ColorServiceProtocol {
  func generateColors(runLoop: RunLoop = .main) -> AnyPublisher<Color, Never> {
    generateColors(runLoop: runLoop)
  }
}

class ColorService: ColorServiceProtocol {
  private var index: Int = 0
  
  func getNextColor() -> Color {
    let selection = self.index % 7
    self.index = self.index + 1
    switch selection {
    case 0: return .blue
    case 1: return .green
    case 2: return .orange
    case 3: return .pink
    case 4: return .purple
    case 5: return .red
    case 6: return .yellow
    default: return .white
    }
  }
  
  func generateColors(runLoop: RunLoop = .main) -> AnyPublisher<Color, Never> {
    return Timer.publish(every: 1.0, on: runLoop, in: .default)
      .autoconnect()
      .map { timer in
        let selection = Int(timer.timeIntervalSince1970 * 1.5) % 7
        switch selection {
        case 0: return .blue
        case 1: return .green
        case 2: return .orange
        case 3: return .pink
        case 4: return .purple
        case 5: return .red
        case 6: return .yellow
        default: return .white
        }
      }
      .eraseToAnyPublisher()
  }
}
