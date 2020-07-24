//
//  SignInViewModel.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import Foundation
import Combine
import CombineExt

protocol SignInViewModelDelegate: AnyObject {
  func signInViewModelDidCancel(_ source: SignInViewModel)
  func signInViewModelDidSignIn(_ source: SignInViewModel)
}

class SignInViewModel: ViewModel {
  private let authenticationService: AuthenticationServiceProtocol
  
  private weak var delegate: SignInViewModelDelegate?
  
  @Published var username: String = .empty
  @Published var password: String = .empty
  
  let cancel: PassthroughSubject<Void, Never> = PassthroughSubject()
  let signIn: PassthroughSubject<Void, Never> = PassthroughSubject()
  
  private(set) var canSignIn: AnyPublisher<Bool, Never>!
  
  private var cancelBag: CancelBag!
  
  init(authenticationService: AuthenticationServiceProtocol) {
    self.authenticationService = authenticationService
    
    self.canSignIn = [
      self.$username,
      self.$password
    ]
      .combineLatest()
      .map {
        $0.allSatisfy { !$0.isEmpty }
      }
      .eraseToAnyPublisher()
  }
  
  func setup(delegate: SignInViewModelDelegate) -> Self {
    self.delegate = delegate
    bind()
    return self
  }
  
  private func bind() {
    self.cancelBag = CancelBag()
    
    let authenticationService = self.authenticationService
    
    self.cancel
      .sink(receiveValue: { [weak self] in
        guard let self = self else { return }
        self.endEditing()
        self.delegate?.signInViewModelDidCancel(self)
      })
      .store(in: &self.cancelBag)
    
    self.signIn
      .withLatestFrom(
        self.$username,
        self.$password)
      .setFailureType(to: Error.self)
      .flatMapLatest { username, password -> AnyPublisher<User, Error> in
        authenticationService
          .signIn(username: username, password: password)
      }
      .sink(receiveValue: { [weak self] user in
        guard let self = self else { return }
        self.delegate?.signInViewModelDidSignIn(self)
      })
      .store(in: &self.cancelBag)
  }
}
