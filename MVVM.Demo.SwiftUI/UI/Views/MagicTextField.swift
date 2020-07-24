//
//  MagicTextField.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 7/16/20.
//

import SwiftUI

struct MagicTextField: View {
    let title: String
    @Binding var text: String
    @State var test: String = .empty
    let isSecure: Bool
    
    @State private var showSmallTitle: Bool = false
    
    init(_ title: String, text: Binding<String>, isSecure: Bool = false) {
        self.title = title
        self._text = text
        self.isSecure = isSecure
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text(self.title)
                .foregroundColor(Color.white)
                .colorMultiply(self.text.isEmpty ? Color.tertiaryLabel : Color.label)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
                .scaleEffect(self.text.isEmpty ? 1.0 : 0.6, anchor: .leading)
                .offset(
                    x: self.text.isEmpty ? 0.0 : 8.0,
                    y: self.text.isEmpty ? 0.0 : -16.0)
                .animation(.easeInOut(duration: self.text.isEmpty ? 0.2 : 0.24))
            
            if self.isSecure {
                SecureField(String.empty, text: self.$text)
                    .frame(height: 48)
                    .padding(.leading, 16)
            } else {
                TextField(String.empty, text: self.$text)
                    .frame(height: 48)
                    .padding(.leading, 16)
            }
        }
        .overlay(Capsule(style: .continuous).stroke(Color.secondarySystemFill, lineWidth: 1))
        .frame(minWidth: 0, maxWidth: .infinity)
        .fixedSize(horizontal: false, vertical: true)
        .onReceive(self.text.publisher) { text in
            withAnimation {
                self.showSmallTitle = !text.description.isEmpty
            }
        }
    }
}

struct MagicTextField_Previews: PreviewProvider {
    @State static var title: String = "Title"
    @State static var emptyText: String = String.empty
    
    static var previews: some View {
        VStack {
            MagicTextField(
                "Magic Text Field",
                text: self.$emptyText)
            
            MagicTextField(
                "Secured Magic Text Field",
                text: self.$emptyText,
                isSecure: true)
        }
        .padding()
    }
}
