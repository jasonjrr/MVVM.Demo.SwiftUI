//
//  SettingsViewModel.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 7/17/20.
//

import Foundation

protocol SettingsViewModelDelegate: class {
    func settingsViewModelOnDismiss(_ source: SettingsViewModel)
}

class SettingsViewModel: ViewModel {
    private weak var delegate: SettingsViewModelDelegate?
    
    @discardableResult
    func setup(delegate: SettingsViewModelDelegate) -> Self {
        self.delegate = delegate
        return self
    }
    
    func onDismiss() {
        self.delegate?.settingsViewModelOnDismiss(self)
    }
}
