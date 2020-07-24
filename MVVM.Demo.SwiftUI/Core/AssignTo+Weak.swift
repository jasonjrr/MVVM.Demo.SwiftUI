//
//  AssignTo+Weak.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 7/18/20.
//

import Foundation
import Combine

extension Publisher where Failure == Never {
    func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on root: Root) -> AnyCancellable {
       sink { [weak root] in
            root?[keyPath: keyPath] = $0
        }
    }
}
