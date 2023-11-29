//
//  AppRootCoordinatorView.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import SwiftUI

struct AppRootCoordinatorView: View {
  @Environment(\.alertManager) var alertManager: AlertManager
  
  @State var coordinator: AppRootCoordinator
  
  @State private var colorWizardCoordinator: ColorWizardCoordinator?
  @State private var signInViewModel: SignInViewModel?
  @State private var alert: AlertService.AlertPackage?
  
  var body: some View {
    ObjectNavigationStack(path: self.coordinator.path) {
      ZStack {
        LandingView(viewModel: self.coordinator.landingViewModel)
          .zIndex(0)
          .navigationDestination(for: PulseViewModel.self) {
            PulseView(viewModel: $0)
          }
          .fullScreenCover(item: self.$colorWizardCoordinator) { coordinator in
            ColorWizardCoordinatorView(coordinator: coordinator)
          }
        
        if let viewModel = self.signInViewModel {
          SignInView(viewModel: viewModel)
            .zIndex(100)
        }
      }
    }
    .navigationAlert(item: self.$alert)
    .onChange(of: self.coordinator.colorWizardCoordinator, initial: true) { _, value in
      self.colorWizardCoordinator = value
    }
    .onChange(of: self.alertManager.alert, initial: true) { _, value in self.alert = value }
    .onChange(of: self.coordinator.signInViewModel, initial: true) { _, value in
      self.signInViewModel = value
    }
  }
}
