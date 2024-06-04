//
//  AppRootCoordinatorView.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import SwiftUI

struct AppRootCoordinatorView: View {
  @Environment(\.alertManager) var alertManager: AlertManager
  
  @Bindable var coordinator: AppRootCoordinator
  
  @State private var colorWizardCoordinator: ColorWizardCoordinator?
  @State private var infiniteCardsViewModel: InfiniteCardsViewModel?
  @State private var signInViewModel: SignInViewModel?
  @State private var alert: AlertService.AlertPackage?
  
  var body: some View {
    ObjectNavigationStack(path: self.coordinator.path) {
      LandingView(viewModel: self.coordinator.landingViewModel)
        .navigationDestination(for: PulseViewModel.self) {
          PulseView(viewModel: $0)
        }
        .fullScreenCover(item: self.$infiniteCardsViewModel) { viewModel in
          NavigationStack {
            InfiniteCardsView(viewModel: viewModel)
          }
        }
        .fullScreenCover(item: self.$colorWizardCoordinator) { coordinator in
          ColorWizardCoordinatorView(coordinator: coordinator)
        }
    }
    .overlay {
      if let viewModel = self.signInViewModel {
        SignInView(viewModel: viewModel)
      }
    }
    .navigationAlert(item: self.$alert)
    .onChange(of: self.coordinator.colorWizardCoordinator, initial: true) { _, value in
      self.colorWizardCoordinator = value
    }
    .onChange(of: self.coordinator.infiniteCardsViewModel, initial: true) { _, value in
      self.infiniteCardsViewModel = value
    }
    .onChange(of: self.alertManager.alert, initial: true) { _, value in self.alert = value }
    .onChange(of: self.coordinator.signInViewModel, initial: true) { _, value in
      self.signInViewModel = value
    }
  }
}
