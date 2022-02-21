//
//  LoginView.swift
//  ChatStreamApp
//
//  Created by 1 on 05/11/21.
//

import SwiftUI

struct PhLoginView: View {
    
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
        VStack {
            
            Image(systemName: "person.crop.circle.fill")
            
            HStack {
                
                TextField("+998/(--)", text: $loginViewModel.countryCode)
                    .keyboardType(.numberPad)
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .frame(width: 100)
                    .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(loginViewModel.countryCode == "" ? Color.gray : Color.pink, lineWidth: 1.5)
                    )
                
                TextField("--- -- --", text: $loginViewModel.phoneNum)
                    .keyboardType(.numberPad)
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(loginViewModel.phoneNum == "" ? Color.gray : Color.pink, lineWidth: 1.5)
                    )
                
            } //: HS
            .padding(.top, 20)
            
            Button {
                loginViewModel.verifyUser()
            } label: {
                Text("Login")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(Color.pink)
                    .cornerRadius(8)
            } //: BT
            .disabled(loginViewModel.countryCode == "" || loginViewModel.phoneNum == "")
            .opacity(loginViewModel.countryCode == "" || loginViewModel.phoneNum == "" ? 0.6 : 1)
            .padding(.top, 20)
            
            Spacer()
            
        } //: VS
        .padding()
    }
}

struct PhLoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
