//
//  ColorWizardConfiguration+Mock.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/17/21.
//

import Foundation

extension ColorWizardConfiguration {
  static func mock() -> ColorWizardConfiguration {
    ColorWizardConfiguration(pages: [
      .page("First Color", color: .green),
      .page("Second Color", color: .orange),
      .page("Third Color", color: .systemIndigo),
      .page("Fourth Color", color: .pink),
      .page("Fifth Color", color: .purple),
      .page("Summary", colors: [
        .green,
        .orange,
        .systemIndigo,
        .pink,
        .purple,
      ]),
    ])
  }
}
