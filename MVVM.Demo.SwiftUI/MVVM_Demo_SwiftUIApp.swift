//
//  MVVM_Demo_SwiftUIApp.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import SwiftUI
import BusyIndicator

private let appAssembler: AppAssembler = AppAssembler()

@main
struct MVVM_Demo_SwiftUIApp: App {
  var body: some Scene {
    WindowGroup {
      AppRootCoordinatorView(
        coordinator: appAssembler.resolver.resolved(AppRootCoordinator.self)
      )
      .alertManager(appAssembler.resolver.resolved(AlertManager.self))
      .busyIndicator(appAssembler.resolver.resolved(BusyIndicatorServiceProtocol.self).busyIndicator)
    }
  }
}
