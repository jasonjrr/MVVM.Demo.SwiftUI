//
//  SettingsView.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 7/17/20.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var coordinator: AppRootNavigationCoordinator
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        List {
            Text("This screen is deliberately left empty and meant to be used during mentoring or hands-on coding interviews.")
        }
        .navigationTitle("Settings")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.viewModel.onDismiss()
                }, label: {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .padding([.leading, .trailing], 16)
                        .offset(x: -16, y: 0)
                })
                .buttonStyle(ToolbarButtonStyle())
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let appAssembler: AppAssembler = AppAssembler()
        let coordinator = appAssembler.resolver.resolve(AppRootNavigationCoordinator.self)!
        let viewModel = appAssembler.resolver.resolve(SettingsViewModel.self)!
        NavigationView {
            SettingsView(viewModel: viewModel)
                .environmentObject(coordinator)
        }
    }
}
