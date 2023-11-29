//
//  ColorWizardCoordinatorView.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/17/21.
//

import SwiftUI

struct ColorWizardCoordinatorView: View {
  @State var coordinator: ColorWizardCoordinator
  
  var body: some View {
    ObjectNavigationStack(path: self.coordinator.path) {
      ColorWizardContentView(viewModel: self.coordinator.rootContentViewModel)
        .navigationDestination(for: ColorWizardContentViewModel.self) {
          ColorWizardContentView(viewModel: $0)
        }
    }
  }
}
