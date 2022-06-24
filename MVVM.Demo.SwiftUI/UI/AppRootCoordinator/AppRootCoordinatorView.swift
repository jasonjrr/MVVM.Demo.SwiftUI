//
//  AppRootCoordinatorView.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import SwiftUI

struct AppRootCoordinatorView: View {
  @Environment(\.alertManager) var alertManager: AlertManager
  
  @ObservedObject var coordinator: AppRootCoordinator
  
  @State private var signInViewModel: SignInViewModel?
  @State private var alert: AlertService.AlertPackage?
  
  init(coordinator: AppRootCoordinator) {
    self.coordinator = coordinator
  }
  
  var body: some View {
    NavigationView {
      ZStack {
        LandingView(viewModel: self.coordinator.landingViewModel)
          .zIndex(0)
          .navigation(item: self.$coordinator.pulseViewModel) {
            PulseView(viewModel: $0)
          }
          .fullScreenCover(item: self.$coordinator.colorWizardCoordinator) { coordinator in
            NavigationView {
              ColorWizardCoordinatorView(coordinator: coordinator)
            }
          }
        
        if let viewModel = self.signInViewModel {
          SignInView(viewModel: viewModel)
            .zIndex(100)
        }
      }
    }
    .navigationAlert(item: self.$alert)
    .onReceive(self.alertManager.$alert) { self.alert = $0 }
    .onReceive(self.coordinator.$signInViewModel, withAnimation: .easeInOut(duration: 0.375)) {
      self.signInViewModel = $0
    }
  }
}
