//
//  AppAssembly.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 7/15/20.
//

import Foundation
import Swinject

class AppAssembler {
    private let assembler: Assembler
    
    var resolver: Resolver { self.assembler.resolver }
    
    init() {
        self.assembler = Assembler([
            AppAssembly(),
        ])
    }
}

class AppAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: Services
        container.register(AuthenticationService.self) { resolver in
            AuthenticationService()
        }.inObjectScope(.container)
        
        container.register(ColorService.self) { resolver in
            ColorService()
        }.inObjectScope(.container)
        
        // MARK: Coordinators
        
        container.register(AppRootNavigationCoordinator.self) { resolver in
            AppRootNavigationCoordinator(resolver: resolver)
        }.inObjectScope(.container)
        
        // MARK: View Models
        
        container.register(ContentViewModel.self) { resolver in
            ContentViewModel(
                authenticationService: resolver.resolve(AuthenticationService.self)!,
                colorService: resolver.resolve(ColorService.self)!)
        }.inObjectScope(.container)
        
        container.register(PartyViewModel.self) { resolver in
            PartyViewModel(
                colorService: resolver.resolve(ColorService.self)!)
        }.inObjectScope(.transient)
        
        container.register(SettingsViewModel.self) { resolver in
            SettingsViewModel()
        }.inObjectScope(.transient)
        
        container.register(SignInViewModel.self) { resolver in
            SignInViewModel(
                authenticationService: resolver.resolve(AuthenticationService.self)!)
        }.inObjectScope(.transient)
    }
}
