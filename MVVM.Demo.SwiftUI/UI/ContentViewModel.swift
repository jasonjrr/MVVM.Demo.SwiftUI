//
//  ContentViewModel.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 7/15/20.
//

import Foundation
import Combine
import SwiftUI

protocol ContentViewModelDelegate: class {
    func contentViewModelDidTapSettings(_ source: ContentViewModel)
    func contentViewModelDidTapSignIn(_ source: ContentViewModel)
    func contentViewModelDidTapOutsideModal(_ source: ContentViewModel)
    func contentViewModelDidTapParty(_ source: ContentViewModel)
}

class ContentViewModel: ViewModel {
    private let authenticationService: AuthenticationService
    private let colorService: ColorService
    
    private weak var delegate: ContentViewModelDelegate?
    
    @Published private(set) var greetingName: String = "stranger"
    @Published private(set) var partyColor: Color
    
    var isAuthenticated: AnyPublisher<Bool, Never> { self.authenticationService.isAuthenticated }
    
    private var cancelBag: CancelBag = CancelBag()
    
    init(authenticationService: AuthenticationService, colorService: ColorService) {
        self.authenticationService = authenticationService
        self.colorService = colorService
        self.partyColor = colorService.getNextColor()
        
        self.authenticationService.$userName
            .map { $0 ?? "stranger" }
            .map { $0! }
            .assign(to: \.greetingName, on: self)
            .store(in: &self.cancelBag)
        
        self.colorService.generateColors()
            .assign(to: \.partyColor, on: self)
            .store(in: &self.cancelBag)
    }
    
    @discardableResult
    func setup(delegate: ContentViewModelDelegate) -> Self {
        self.delegate = delegate
        return self
    }
    
    func didTapSettings() {
        self.delegate?.contentViewModelDidTapSettings(self)
    }
    
    func didTapSignIn() {
        self.delegate?.contentViewModelDidTapSignIn(self)
    }
    
    func didTapSignOut() {
        self.authenticationService.signOut()
    }
    
    func didTapParty() {
        self.delegate?.contentViewModelDidTapParty(self)
    }
    
    func didTapOutsideModal() {
        self.delegate?.contentViewModelDidTapOutsideModal(self)
    }
}
