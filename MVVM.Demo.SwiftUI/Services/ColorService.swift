//
//  ColorService.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import Foundation
import Combine

enum ColorModel {
  case blue
  case green
  case orange
  case pink
  case purple
  case red
  case yellow
  case white
}

protocol ColorServiceProtocol: AnyObject {
  func getNextColor() -> ColorModel
  func generateColors(runLoop: RunLoop) -> AnyPublisher<ColorModel, Never>
}

extension ColorServiceProtocol {
  func generateColors(runLoop: RunLoop = .main) -> AnyPublisher<ColorModel, Never> {
    generateColors(runLoop: runLoop)
  }
}

class ColorService: ColorServiceProtocol {
  private var index: Int = 0
  
  func getNextColor() -> ColorModel {
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
  
  func generateColors(runLoop: RunLoop = .main) -> AnyPublisher<ColorModel, Never> {
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
