//
//  ColorWizardPageCoordinatorView.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/17/21.
//

import SwiftUI

struct ColorWizardPageCoordinatorView: View {
  @ObservedObject var coordinator: ColorWizardPageCoordinator
  
  var body: some View {
    ColorWizardContentView(viewModel: self.coordinator.contentViewModel)
      .navigation(item: self.$coordinator.nextPageCoordinator) { coordinator in
        ColorWizardPageCoordinatorView(coordinator: coordinator)
      }
  }
}
