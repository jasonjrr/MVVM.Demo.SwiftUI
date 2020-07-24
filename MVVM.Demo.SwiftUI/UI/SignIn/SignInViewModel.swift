//
//  SignInViewModel.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 7/16/20.
//

import Foundation
import Combine

protocol SignInViewModelDelegate: class {
    func signInViewModelOnSignIn(_ source: SignInViewModel)
    func signInViewModelOnDismiss(_ source: SignInViewModel)
}

class SignInViewModel: ViewModel {
    private let authenticationService: AuthenticationService
    private var delegate: SignInViewModelDelegate?
    
    @Published var userName: String = .empty
    @Published var password: String = .empty
    
    private(set) var isSignInEnabled: AnyPublisher<Bool, Never>!
    
    private var cancelBag: CancelBag = CancelBag()
    
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
        
        self.isSignInEnabled = self.$userName
            .combineLatest(self.$password)
            .map { !$0.isEmpty && !$1.isEmpty }
            .eraseToAnyPublisher()
    }
    
    @discardableResult
    func setup(delegate: SignInViewModelDelegate) -> Self {
        self.delegate = delegate
        return self
    }
    
    func doSignIn() {
        self.authenticationService.signIn(
            userName: self.userName,
            password: self.password)
        self.delegate?.signInViewModelOnSignIn(self)
    }
    
    func dismiss() {
        self.delegate?.signInViewModelOnDismiss(self)
    }
}
