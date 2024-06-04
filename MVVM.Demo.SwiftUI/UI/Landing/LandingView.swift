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
  
  @Bindable var viewModel: LandingViewModel
  
  @State private var isAuthenticated: Bool = false
  @State private var username: String = .empty
  @State private var pulseColor: Color = .accentColor
  
  var body: some View {
    VStack(alignment: .center, spacing: 24.0) {
      signInOutButton()
      pulseButton()
      infiniteCardsButton()
      colorWizardButton()
    }
    .padding([.leading, .trailing], max(56.0 - self.inverseHorizontalPadding, 4.0))
    .navigationBarHidden(true)
    .onReceive(self.viewModel.isAuthenticated.receive(on: .main)) {
      self.isAuthenticated = $0
    }
    .onReceive(self.viewModel.username.receive(on: .main)) {
      self.username = $0
    }
    .onReceive(self.viewModel.pulseColor.receive(on: .main), withAnimation: .easeInOut) {
      self.pulseColor = $0.asColor()
    }
  }
  
  private func signInOutButton() -> some View {
    Button(action: self.viewModel.signInOrOut) {
      Text(self.isAuthenticated ? "Sign Out, \(self.username)" : "Sign In")
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
    .buttonStyle(.brightBorderedButton(color: self.pulseColor))
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

#if DEBUG
struct LandingView_Previews: PreviewProvider {
  static let appAssembler = AppAssembler()
  static let viewModel = appAssembler.resolver.resolved(LandingViewModel.self)
  
  static var previews: some View {
    Group {
      LandingView(viewModel: viewModel)
    }
  }
}
#endif
