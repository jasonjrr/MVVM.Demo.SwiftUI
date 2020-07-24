//
//  AuthenticationService.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 7/15/20.
//

import Foundation
import Combine

class AuthenticationService {
    @Published private(set) var userName: String?
    @Published private(set) var password: String?
    
    private(set) var isAuthenticated: AnyPublisher<Bool, Never>!
    
    init() {
        self.isAuthenticated = self.$userName
            .combineLatest(self.$password)
            .map { userName, password in
                guard let userName = userName,
                      let password = password,
                      !userName.isEmpty,
                      !password.isEmpty
                      else {
                    return false
                }
                return true
            }
            .eraseToAnyPublisher()
    }
    
    func signIn(userName: String, password: String) {
        self.userName = userName
        self.password = password
    }
    
    func signOut() {
        self.userName = nil
        self.password = nil
    }
}
