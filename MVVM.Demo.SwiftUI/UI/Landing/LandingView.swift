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
  
  @State var viewModel: LandingViewModel
  
  @State private var isAuthenticated: Bool = false
  @State private var username: String = .empty
  @State private var pulseColor: Color = .accentColor
  
  var body: some View {
    ZStack {
      VStack(alignment: .center, spacing: 24.0) {
        Button(action: self.viewModel.signInOrOut) {
          Text(self.isAuthenticated ? "Sign Out, \(self.username)" : "Sign In")
            .multilineTextAlignment(.center)
            .lineLimit(nil)
            .padding(self.buttonPadding)
            .frame(maxWidth: .infinity, minHeight: 54.0)
            .contentShape(Rectangle())
        }
        .buttonStyle(.brightBorderedButton)
        .busyOverlay()
        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
        
        Button(action: self.viewModel.pulse) {
          Text("Pulse")
            .padding(self.buttonPadding)
            .frame(maxWidth: .infinity, minHeight: 54.0)
            .contentShape(Rectangle())
        }
        .buttonStyle(.brightBorderedButton(color: self.pulseColor))
        
        Button(action: self.viewModel.colorWizard) {
          Text("Color Wizard")
            .lineLimit(1)
            .minimumScaleFactor(0.75)
            .padding(self.buttonPadding)
            .frame(maxWidth: .infinity, minHeight: 54.0)
            .contentShape(Rectangle())
        }
        .buttonStyle(.brightBorderedButton)
      }
      .padding([.leading, .trailing], max(56.0 - self.inverseHorizontalPadding, 4.0))
    }
    .navigationBarHidden(true)
    .onReceive(self.viewModel.isAuthenticated.receive(on: .main)) {
      self.isAuthenticated = $0
    }
    .onReceive(self.viewModel.username.receive(on: .main)) {
      self.username = $0
    }
    .onReceive(self.viewModel.pulseColor.receive(on: .main), withAnimation: .easeInOut) {
      switch $0 {
      case .blue: self.pulseColor = .blue
      case .green: self.pulseColor = .green
      case .orange: self.pulseColor = .green
      case .pink: self.pulseColor = .pink
      case .purple: self.pulseColor = .purple
      case .red: self.pulseColor = .red
      case .white: self.pulseColor = .white
      case .yellow: self.pulseColor = .yellow
      }
    }
  }
}

#if DEBUG
struct LandingView_Previews: PreviewProvider {
  static let appAssembler = AppAssembler()
  static let viewModel = appAssembler.resolver.resolve(LandingViewModel.self)!
  
  static var previews: some View {
    Group {
      LandingView(viewModel: viewModel)
    }
  }
}
#endif
