//
//  AppAssembler.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import Foundation
import Swinject

class AppAssembler {
  private let assembler: Assembler
  
  var resolver: Resolver { self.assembler.resolver }
  
  init() {
    self.assembler = Assembler([
      CoordinatorAssembly(),
      ServiceAssembly(),
      ViewModelAssembly(),
    ])
  }
}
