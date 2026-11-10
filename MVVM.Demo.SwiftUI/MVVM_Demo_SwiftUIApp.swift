//
//  MVVM_Demo_SwiftUIApp.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import SwiftUI
import BusyIndicator

@main
struct MVVM_Demo_SwiftUIApp: App {
  private let appAssembler: AppAssembler = AppAssembler()
  
  var body: some Scene {
    WindowGroup {
      AppNavigationCoordinatorView(
        coordinator: self.appAssembler.resolver.resolved(AppNavigationCoordinatorViewModel.self))
      .environment(self.appAssembler.resolver.resolved(AlertManager.self))
      .busyIndicator(self.appAssembler.resolver.resolved(BusyIndicatorServiceProtocol.self).busyIndicator)
    }
  }
}
