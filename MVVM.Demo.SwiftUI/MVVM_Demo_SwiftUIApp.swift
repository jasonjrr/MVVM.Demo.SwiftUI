//
//  MVVM_Demo_SwiftUIApp.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import SwiftUI

private let appAssembler: AppAssembler = AppAssembler()

@main
struct MVVM_Demo_SwiftUIApp: App {
  var body: some Scene {
    WindowGroup {
      AppRootCoordinatorView(
        coordinator: appAssembler.resolver.resolve(AppRootCoordinator.self)!
      )
      .alertManager(appAssembler.resolver.resolve(AlertManager.self)!)
    }
  }
}
