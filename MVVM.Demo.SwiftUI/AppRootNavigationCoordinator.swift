//
//  AppRootNavigationCoordinator.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 7/15/20.
//

import Foundation
import Combine
import Swinject

class AppRootNavigationCoordinator: NavigationCoordinator {
    private let resolver: Resolver
    
    @Published var showSignInPrompt: Bool = false
    @Published var showParty: Bool = false
    @Published var showSettings: Bool = false
    @Published var showSignOutAlert: Bool = false
    
    private(set) var settingsViewModelProvider: ViewModelProvider<SettingsViewModel>!
    private(set) var signInViewModelProvider: ViewModelProvider<SignInViewModel>!
    private(set) var partyViewModelProvider: ViewModelProvider<PartyViewModel>!
    
    private var cancelBag: CancelBag = CancelBag()
    
    init(resolver: Resolver) {
        self.resolver = resolver
        
        self.settingsViewModelProvider = ViewModelProvider(resolver: resolver, afterResolve: { [weak self] in
            guard let self = self else { return }
            $0.setup(delegate: self)
        })
        self.signInViewModelProvider = ViewModelProvider(resolver: resolver, afterResolve: { [weak self] in
            guard let self = self else { return }
            $0.setup(delegate: self)
        })
        self.partyViewModelProvider = ViewModelProvider(resolver: resolver, afterResolve: { [weak self] in
            guard let self = self else { return }
            $0.setup(delegate: self)
        })
    }
}

// MARK: Routes

extension AppRootNavigationCoordinator {
    enum Route {
        case root
        case signIn
        case party
        case settings(AppRootNavigationCoordinator.Route.Settings)
        
        enum Settings {
            case root
        }
    }
    
    private func route(to route: Route) {
        var showSignInPrompt: Bool = false
        var showParty: Bool = false
        var showSettings: Bool = false
        
        switch route {
        case .root: break
        case .signIn:
            showSignInPrompt = true
        case .party:
            showParty = true
        case .settings(let settings):
            showSettings = true
            switch settings {
            case .root: break
            }
        }
        
        self.showSignInPrompt = showSignInPrompt
        self.showParty = showParty
        self.showSettings = showSettings
    }
    
    func pop(from route: Route) {
        switch route {
        case .root: break
        case .signIn: self.route(to: .root)
        case .party: self.route(to: .root)
        case .settings(let settingsRoute):
            switch settingsRoute {
            case .root: self.route(to: .root)
            }
        }
    }
}

// MARK: Alerts

extension AppRootNavigationCoordinator {
    enum Alert {
        case hide
        case signOutAlert
    }
    
    func alert(_ alert: Alert) {
        var showSignOutAlert: Bool = false
        
        switch alert {
        case .hide: break
        case .signOutAlert:
            showSignOutAlert = true
        }
        
        self.showSignOutAlert = showSignOutAlert
    }
}

// MARK: ContentViewModelDelegate

extension AppRootNavigationCoordinator: ContentViewModelDelegate {
    func contentViewModelDidTapSettings(_ source: ContentViewModel) {
        route(to: .settings(.root))
    }
    
    func contentViewModelDidTapSignIn(_ source: ContentViewModel) {
        route(to: .signIn)
    }
    
    func contentViewModelDidTapOutsideModal(_ source: ContentViewModel) {
        route(to: .root)
    }
    
    func contentViewModelDidTapParty(_ source: ContentViewModel) {
        route(to: .party)
    }
}

// MARK: SettingsViewModelDelegate

extension AppRootNavigationCoordinator: SettingsViewModelDelegate {
    func settingsViewModelOnDismiss(_ source: SettingsViewModel) {
        pop(from: .settings(.root))
    }
}

// MARK: SignInViewModelDelegate

extension AppRootNavigationCoordinator: SignInViewModelDelegate {
    func signInViewModelOnSignIn(_ source: SignInViewModel) {
        route(to: .party)
    }
    
    func signInViewModelOnDismiss(_ source: SignInViewModel) {
        pop(from: .signIn)
    }
}

// MARK: PartyViewModelDelegate

extension AppRootNavigationCoordinator: PartyViewModelDelegate {
    func partyViewModelOnDismiss(_ source: PartyViewModel) {
        pop(from: .party)
    }
}
