//
//  SignInView.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import SwiftUI

struct SignInView: View {
  @ObservedObject var viewModel: SignInViewModel
  
  @State private var showCard: Bool = false
  @State private var signInDisabled: Bool = true
  
  var body: some View {
    VStack {
      Spacer()
      if self.showCard {
        CardView(color: Color.systemBackground.opacity(0.5), cornerRadius: .large) {
          VStack {
            VStack(alignment: .leading) {
              Text("User Name")
              TextField("User Name", text: self.$viewModel.username, prompt: nil)
              Text("Password").padding(.top)
              SecureField("Password", text: self.$viewModel.password, prompt: nil)
            }
            .padding(24.0)
            
            HStack {
              Button(action: self.viewModel.cancel) {
                Text("Cancel")
                  .font(.system(size: 18.0))
                  .bold()
                  .frame(maxWidth: .infinity, minHeight: 48.0, idealHeight: 48.0, maxHeight: 48.0)
                  .contentShape(Rectangle())
              }
              
              Button(action: self.viewModel.signIn) {
                Text("Sign In")
                  .font(.system(size: 18.0))
                  .frame(maxWidth: .infinity, minHeight: 48.0, idealHeight: 48.0, maxHeight: 48.0)
                  .contentShape(Rectangle())
              }
              .disabled(self.signInDisabled)
              
            }
            .padding(.bottom)
          }
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(36.0)
        .transition(.scale(scale: 0.0))
      }
      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
      VisualEffectView(effect: UIBlurEffect(style: .regular))
        .edgesIgnoringSafeArea(.all)
    )
    .onAppear {
      withAnimation(.spring()) {
        self.showCard = true
      }
    }
    .onReceive(self.viewModel.canSignIn) {
      self.signInDisabled = !$0
    }
  }
}
