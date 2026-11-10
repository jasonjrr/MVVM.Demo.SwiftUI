//
//  LandingView.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import SwiftUI

struct LandingView: View {
  @ScaledMetric private var buttonPadding: CGFloat = 8.0
  @ScaledMetric private var inverseHorizontalPadding: CGFloat = 8.0
  
  private let buttonMinHeight: CGFloat = 54.0
  
  @Bindable private var viewModel: LandingViewModel
  
  init(viewModel: LandingViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    VStack(alignment: .center, spacing: 24.0) {
      signInOutButton()
      pulseButton()
      infiniteCardsButton()
      colorWizardButton()
    }
    .padding([.leading, .trailing], max(56.0 - self.inverseHorizontalPadding, 4.0))
    .navigationBarHidden(true)
  }
  
  private func signInOutButton() -> some View {
    Button(action: self.viewModel.signInOrOut) {
      Text(self.viewModel.isAuthenticated ? "Sign Out, \(self.viewModel.username)" : "Sign In")
        .multilineTextAlignment(.center)
        .lineLimit(nil)
        .padding(self.buttonPadding)
        .frame(maxWidth: .infinity, minHeight: self.buttonMinHeight)
        .contentShape(Rectangle())
    }
    .buttonStyle(.brightBorderedButton)
    .busyOverlay()
    .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
  }
  
  private func pulseButton() -> some View {
    Button(action: self.viewModel.pulse) {
      Text("Pulse")
        .padding(self.buttonPadding)
        .frame(maxWidth: .infinity, minHeight: self.buttonMinHeight)
        .contentShape(Rectangle())
    }
    .buttonStyle(.brightBorderedButton(color: self.viewModel.pulseColor?.asColor() ?? .accentColor))
    .animation(.easeInOut, value: self.viewModel.pulseColor)
  }
  
  private func infiniteCardsButton() -> some View {
    Button(action: self.viewModel.infiniteCards) {
      Text("Infinite Cards")
        .lineLimit(1)
        .minimumScaleFactor(0.75)
        .padding(self.buttonPadding)
        .frame(maxWidth: .infinity, minHeight: self.buttonMinHeight)
        .contentShape(Rectangle())
    }
    .buttonStyle(.brightBorderedButton)
  }
  
  private func colorWizardButton() -> some View {
    Button(action: self.viewModel.colorWizard) {
      Text("Color Wizard")
        .lineLimit(1)
        .minimumScaleFactor(0.75)
        .padding(self.buttonPadding)
        .frame(maxWidth: .infinity, minHeight: self.buttonMinHeight)
        .contentShape(Rectangle())
    }
    .buttonStyle(.brightBorderedButton)
  }
}

#Preview {
  LandingView(viewModel: AppAssembler().resolver.resolved(LandingViewModel.self))
}
