//
//  SignInView.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 7/16/20.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var viewModel: SignInViewModel
    let parentNamespace: Namespace.ID
    
    @State private var isSignInEnabled: Bool = false
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Sign In")
                .font(.largeTitle)
                .padding(.horizontal)
                .padding(.top, 24)
            Text("Enter your user name and password to sign in!")
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            Text("This is fake, you can actually enter anything you want.")
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 13))
                .foregroundColor(Color.secondaryLabel)
                .padding(.horizontal)
            
            MagicTextField("User Name", text: self.$viewModel.userName)
                .padding(.horizontal)
            MagicTextField("Password", text: self.$viewModel.password, isSecure: true)
                .padding(.horizontal)
            
            HStack(spacing: 16) {
                Button(action: {
                    self.viewModel.dismiss()
                }, label: {
                    Text("Cancel").padding()
                })
                .frame(minWidth: 0, maxWidth: .infinity)
                
                Button(action: {
                    if self.isSignInEnabled {
                        self.viewModel.doSignIn()
                    }
                }, label: {
                    Text("Sign In").padding()
                })
                .frame(minWidth: 0, maxWidth: .infinity)
                .disabled(!self.isSignInEnabled)
                .animation(.easeInOut)
            }
            .padding(.all, 16)
        }
        .background(RoundedRectangle(cornerRadius: 25.0, style: .continuous)
            .fill(Color.secondarySystemBackground).shadow(radius: 12))
        .frame(minWidth: 0, maxWidth: .infinity)
        .onReceive(self.viewModel.isSignInEnabled) { enabled in
            self.isSignInEnabled = enabled
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        let appAssembler: AppAssembler = AppAssembler()
        let viewModel = appAssembler.resolver.resolve(SignInViewModel.self)!
        return ZStack {
            Rectangle()
                .fill(Color.clear)
                .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
                .frame(
                    minWidth: 0, maxWidth: .infinity,
                    minHeight: 0, maxHeight: .infinity)
            SignInView(viewModel: viewModel, parentNamespace: namespace)
                .padding(.all, 24)
        }
    }
}
