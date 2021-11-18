//
//  ColorWizardCoordinatorView.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/17/21.
//

import SwiftUI

struct ColorWizardCoordinatorView: View {
  @ObservedObject var coordiantor: ColorWizardCoordinator
  
  var body: some View {
    ColorWizardPageCoordinatorView(coordinator: self.coordiantor.colorWizardPageCoordinator)
  }
}
