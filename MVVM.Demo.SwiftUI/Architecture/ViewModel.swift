//
//  ViewModel.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import Foundation

typealias ViewModelDefinition = (ObservableObject & Identifiable & HapticFeedbackProvider)

protocol ViewModel: ViewModelDefinition {}
