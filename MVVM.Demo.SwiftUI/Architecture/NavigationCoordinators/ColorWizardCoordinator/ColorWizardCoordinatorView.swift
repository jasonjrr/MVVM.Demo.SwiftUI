//
//  ColorWizardCoordinatorView.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/17/21.
//

import SwiftUI

struct ColorWizardCoordinatorView: View {
  @Bindable private var coordinator: ColorWizardCoordinatorViewModel
  
  init(coordinator: ColorWizardCoordinatorViewModel) {
    self.coordinator = coordinator
  }
  
  var body: some View {
    CoordinatorNavigationStack(path: self.coordinator.path) {
      ColorWizardContentView(viewModel: self.coordinator.rootContentViewModel)
        .navigationDestination(for: ColorWizardContentViewModel.self) {
          ColorWizardContentView(viewModel: $0)
        }
    }
  }
}
