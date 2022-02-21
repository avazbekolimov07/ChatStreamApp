//
//  LoginView.swift
//  ChatStreamApp
//
//  Created by 1 on 30/10/21.
//

import SwiftUI
import StreamChat

struct LoginView: View {
    
    @EnvironmentObject var streamData : StreamViewModel
    
    // changing based on ColorScheme
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            TextField("iJustine", text: $streamData.userName)
                .modifier(ShadowModeifier())
                .padding(.top, 30)
            
            Button {
                streamData.logInUser() // <---------
            } label: {
                HStack {
                    Spacer()
                    
                    Text("Login")
                    
                    Spacer()
                    Image(systemName: "arrow.right")
                    
                } //: HS
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(Color.primary)
                .foregroundColor(colorScheme == .dark ? .black : .white)
                .cornerRadius(5)
            } //: BT
            .padding(.top, 20)
            .disabled(streamData.userName == "")
            .opacity(streamData.userName == "" ? 0.5 : 1)
            
            Spacer()

        } //: VS
        .padding()
    }
}

struct ShadowModeifier: ViewModifier {
    
    // changing based on ColorScheme
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        return content
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(colorScheme != .dark ? Color.white : Color.black)
            .cornerRadius(8)
            .clipped()
            .shadow(color: Color.primary.opacity(0.04),
                    radius: 5, x: 5, y: 5)
            .shadow(color: Color.primary.opacity(0.04),
                    radius: 5, x: -5, y: -5)
        
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
