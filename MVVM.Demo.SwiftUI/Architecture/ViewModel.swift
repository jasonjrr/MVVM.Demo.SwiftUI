//
//  ViewModel.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 7/15/20.
//

import Foundation

typealias ViewModelDefinition = (ObservableObject & Identifiable & HapticFeedbackProvider)

protocol ViewModel: ViewModelDefinition {}
