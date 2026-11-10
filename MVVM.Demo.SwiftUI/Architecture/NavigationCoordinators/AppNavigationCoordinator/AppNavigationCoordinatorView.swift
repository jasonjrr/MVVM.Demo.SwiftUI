//
//  AppNavigationCoordinatorView.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import SwiftUI

struct AppNavigationCoordinatorView: View {
  @Environment(AlertManager.self) private var alertManager: AlertManager
  
  @Bindable private var coordinator: AppNavigationCoordinatorViewModel
  
  init(coordinator: AppNavigationCoordinatorViewModel) {
    self.coordinator = coordinator
  }
  
  var body: some View {
    CoordinatorNavigationStack(path: self.coordinator.path) {
      LandingView(viewModel: self.coordinator.landingViewModel)
        .navigationDestination(for: PulseViewModel.self) {
          PulseView(viewModel: $0)
        }
    }
    .fullScreenCover(item: self.$coordinator.infiniteCardsViewModel) { viewModel in
      NavigationStack {
        InfiniteCardsView(viewModel: viewModel)
      }
    }
    .fullScreenCover(item: self.$coordinator.colorWizardCoordinatorViewModel) { coordinator in
      ColorWizardCoordinatorView(coordinator: coordinator)
    }
    .overlay {
      if let viewModel = self.coordinator.signInViewModel {
        SignInView(viewModel: viewModel)
      }
    }
    .navigationAlert(item: Bindable(self.alertManager).alert)
  }
}
