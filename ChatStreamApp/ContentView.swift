//
//  ContentView.swift
//  ChatStreamApp
//
//  Created by 1 on 30/10/21.
//

import SwiftUI
import StreamChat

struct ContentView: View {
    
    @StateObject var streamData = StreamViewModel()
    @StateObject var loginViewModel = LoginViewModel()
    @AppStorage("log_Status") var logStatus = false
    
    var body: some View {
        NavigationView {
            if !logStatus {
                
                if loginViewModel.newUser {
                    LoginView()
                        .environmentObject(streamData)
                        .navigationBarTitle("Register")
                } else {
                    PhLoginView()
                        .environmentObject(loginViewModel)
                        .navigationBarTitle("Login")
                }
                
            } else  { //: if case
              
                ChannelView()
                    .environmentObject(streamData)
            } //: else case
            
        } //: NAV View
        
        // Since we have different alerts...
        .background(
            ZStack {
                Text("")
                    .alert(isPresented: $loginViewModel.showAlert) {
                        Alert(title: Text("Message"), message: Text(loginViewModel.errorMsg), dismissButton: .destructive(Text("OK"), action: {
                            withAnimation {
                                loginViewModel.isLoading = false
                                }
                            })
                        )
                    }
                
                Text("")
                    .alert(isPresented: $streamData.error) {
                        Alert(title: Text("Message"), message: Text(streamData.errorMsg), dismissButton: .destructive(Text("OK"), action: {
                            withAnimation {
                                streamData.isLoading = false
                                }
                            })
                        )
                    }
            } //: ZS
        )
        
        .overlay(
            ZStack {
                
                // New Channel View...
                if streamData.createNewChannel{CreateNewChannelView()}
                
                // Loading Screen...
                if loginViewModel.isLoading || streamData.isLoading {LoadingScreenView()}
                
                
                
            } //: ZS
        ) //: overlay
        .environmentObject(streamData)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
