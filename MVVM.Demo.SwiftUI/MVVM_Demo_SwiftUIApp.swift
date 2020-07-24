//
//  MVVM_Demo_SwiftUIApp.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 7/15/20.
//

import SwiftUI

private let appAssembler: AppAssembler = AppAssembler()

@main
struct MVVM_Demo_SwiftUIApp: App {
    @StateObject var coordinator: AppRootNavigationCoordinator = appAssembler.resolver.resolve(AppRootNavigationCoordinator.self)!
    @StateObject var contentViewModel: ContentViewModel = appAssembler.resolver.resolve(ContentViewModel.self)!
        .setup(delegate: appAssembler.resolver.resolve(AppRootNavigationCoordinator.self)!)
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: self.contentViewModel)
                .environmentObject(self.coordinator)
        }
    }
}
