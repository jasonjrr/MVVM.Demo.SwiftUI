//
//  ColorService.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 7/16/20.
//

import Foundation
import SwiftUI
import Combine

class ColorService {
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
    
    func generateColors() -> AnyPublisher<Color, Never> {
        return Timer.publish(every: 0.7, on: .main, in: .default)
            .autoconnect()
            .map { timer in
                let selection = Int(timer.timeIntervalSince1970) % 7
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
