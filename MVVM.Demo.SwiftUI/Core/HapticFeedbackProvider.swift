//
//  HapticFeedbackProvider.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 7/15/20.
//

import UIKit

private let impactLightFeedbackGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
private let impactMediumFeedbackGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator()
private let impactHeavyFeedbackGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
private let selectionFeedbackGenerator: UISelectionFeedbackGenerator = UISelectionFeedbackGenerator()
private let notificationFeedbackGenerator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()

enum HapticFeedbackStyle {
  case impactLight
  case impactMedium
  case impactHeavy
  case selection
  case notifySuccess
  case notifyWarning
  case notifyError
}

protocol HapticFeedbackProvider {
  func hapticFeedback(_ style: HapticFeedbackStyle)
}

extension HapticFeedbackProvider {
  func hapticFeedback(_ style: HapticFeedbackStyle) {
    DispatchQueue.main.async {
        switch style {
        case .impactLight:
          impactLightFeedbackGenerator.impactOccurred()
        case .impactMedium:
          impactMediumFeedbackGenerator.impactOccurred()
        case .impactHeavy:
          impactHeavyFeedbackGenerator.impactOccurred()
        case .selection:
          selectionFeedbackGenerator.selectionChanged()
        case .notifySuccess:
          notificationFeedbackGenerator.notificationOccurred(.success)
        case .notifyWarning:
          notificationFeedbackGenerator.notificationOccurred(.warning)
        case .notifyError:
          notificationFeedbackGenerator.notificationOccurred(.error)
        }
    }
  }
}
