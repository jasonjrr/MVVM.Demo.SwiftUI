//
//  AppRootCoordinatorView.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import SwiftUI

struct AppRootCoordinatorView: View {
  @ObservedObject var coordinator: AppRootCoordinator
  
  @State private var signInViewModel: SignInViewModel?
  
  init(coordinator: AppRootCoordinator) {
    self.coordinator = coordinator
  }
  
  var body: some View {
    NavigationView {
      ZStack {
        LandingView(viewModel: self.coordinator.landingViewModel)
          .zIndex(0)
          .navigationAlert(item: self.$coordinator.alert)
          .navigation(item: self.$coordinator.pulseViewModel) {
            PulseView(viewModel: $0)
          }
        
        if let viewModel = self.signInViewModel {
          SignInView(viewModel: viewModel)
            .zIndex(100)
        }
      }
    }
    .onReceive(self.coordinator.$signInViewModel, withAnimation: .easeInOut(duration: 0.375)) {
      self.signInViewModel = $0
    }
  }
}
