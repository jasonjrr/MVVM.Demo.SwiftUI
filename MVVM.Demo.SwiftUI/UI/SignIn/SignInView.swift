//
//  SignInView.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import SwiftUI

struct SignInView: View {
  @ScaledMetric private var buttonFontSize: CGFloat = 18.0
  @ScaledMetric private var inverseCardPadding: CGFloat = 16.0
  
  @State var viewModel: SignInViewModel
  
  @State private var showCard: Bool = false
  @State private var signInDisabled: Bool = true
  
  @FocusState private var focusState: FocusField?
  enum FocusField {
    case username
    case password
  }
  
  var body: some View {
    HStack {
      if self.showCard {
        CardView(color: Color.systemBackground, cornerRadius: .large) {
          VStack {
            VStack(alignment: .leading) {
              Text("User Name")
                .padding(EdgeInsets(horizontal: 8.0, vertical: 0.0))
              TextField("User Name", text: self.$viewModel.username, prompt: nil)
                .focused(self.$focusState, equals: .username)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8.0).stroke(Color.systemGray))
                .contentShape(Rectangle())
                .onTapGesture {
                  if self.focusState != .username {
                    self.focusState = .username
                  }
                }
              Text("Password").padding(.top)
                .padding(EdgeInsets(horizontal: 8.0, vertical: 0.0))
              SecureField("Password", text: self.$viewModel.password, prompt: nil)
                .focused(self.$focusState, equals: .password)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8.0).stroke(Color.systemGray))
                .contentShape(Rectangle())
                .onTapGesture {
                  if self.focusState != .password {
                    self.focusState = .password
                  }
                }
            }
            .padding(16.0)
            .onSubmit {
              switch self.focusState {
              case .none: break
              case .username: self.focusState = .password
              case .password: self.focusState = nil
              }
            }
            
            HStack {
              Button(action: self.viewModel.cancel) {
                Text("Cancel")
                  .lineLimit(1)
                  .minimumScaleFactor(0.75)
                  .font(.system(size: self.buttonFontSize))
                  .bold()
                  .frame(maxWidth: .infinity, minHeight: 48.0, idealHeight: 48.0, maxHeight: 48.0)
                  .contentShape(Rectangle())
              }
              
              Button(action: self.viewModel.signIn) {
                Text("Sign In")
                  .lineLimit(1)
                  .minimumScaleFactor(0.75)
                  .font(.system(size: self.buttonFontSize))
                  .frame(maxWidth: .infinity, minHeight: 48.0)
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
        .padding(max(52.0 - self.inverseCardPadding, 4.0))
        .transition(.scale(scale: 0.0))
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.ultraThinMaterial)
    .onAppear {
      withAnimation(.spring(response: 0.325, dampingFraction: 0.825, blendDuration: 0.2)) {
        self.showCard = true
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        self.focusState = .username
      }
    }
    .onReceive(self.viewModel.canSignIn) {
      self.signInDisabled = !$0
    }
  }
}

#if DEBUG
struct SignInView_Previews: PreviewProvider {
  static let appAssembler = AppAssembler()
  static let viewModel = appAssembler.resolver.resolve(SignInViewModel.self)!
  
  static var previews: some View {
    Group {
      SignInView(viewModel: viewModel)
        .edgesIgnoringSafeArea(.all)
    }
  }
}
#endif
