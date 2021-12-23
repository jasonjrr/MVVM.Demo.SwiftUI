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
        CardView(color: Color.systemBackground, cornerRadius: .large) {
          VStack {
            VStack(alignment: .leading) {
              Text("User Name")
                .padding(EdgeInsets(horizontal: 8.0, vertical: 0.0))
              TextField("User Name", text: self.$viewModel.username, prompt: nil)
                .padding()
                .background(RoundedRectangle(cornerRadius: 3.0).stroke(Color.systemGroupedBackground))
              Text("Password").padding(.top)
                .padding(EdgeInsets(horizontal: 8.0, vertical: 0.0))
              SecureField("Password", text: self.$viewModel.password, prompt: nil)
                .padding()
                .background(RoundedRectangle(cornerRadius: 3.0).stroke(Color.systemGroupedBackground))
            }
            .padding(16.0)
            
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
        .clipped()
        .shadow(radius: 3.0)
        .padding(36.0)
        .transition(.scale(scale: 0.0))
      }
      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
      ProgressiveVisualEffectView(effect: UIBlurEffect(style: .regular), intensity: 0.25)
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
