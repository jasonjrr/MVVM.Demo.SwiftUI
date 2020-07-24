//
//  ViewModelProvider.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 7/17/20.
//

import Foundation
import Swinject
import SwiftUI

class ViewModelProvider<V: ViewModel> {
    private weak var viewModel: V?
    {
        willSet {
            print("## willSet.viewModel \(V.self); value \(self.viewModel) to \(newValue)")
        }
        didSet {
            print("## didSet.viewModel \(V.self); value \(self.viewModel)")
        }
    }
    
    private let resolver: Resolver
    private let afterResolve: ((_ viewModel: V) -> Void)?
    
    init(resolver: Resolver, afterResolve: ((_ viewModel: V) -> Void)? = nil) {
        self.resolver = resolver
        self.afterResolve = afterResolve
    }
    
    func provide() -> V {
        if let viewModel = self.viewModel {
            return viewModel
        }
        print("provide NEW \(V.self)")
        let viewModel = self.resolver.resolve(V.self)!
        afterResolve?(viewModel)
        self.viewModel = viewModel
        return viewModel
    }
    
    func release() {
        self.viewModel = nil
    }
}
