//
//  ChatView.swift
//  ChatStreamApp
//
//  Created by 1 on 31/10/21.
//

import SwiftUI
import StreamChat

struct ChatView: View {
    
    // since its observing object so its automatically observing and refreshing...
    @StateObject var listner: ChatChannelController.ObservableObject
    @Environment(\.colorScheme) var scheme
    
    // Message
    @State var message = ""
    
    // Sending Message
    func sendMessage() {
        // since we created a channel for masseging
        let channelID = ChannelId(type: .messaging, id: listner.channel?.cid.id ?? "")
        ChatClient.shared.channelController(for: channelID)
            .createNewMessage(text: message) { result in
                switch result {
                case .success(let id):
                    print("Success = \(id)")
                case .failure(let error):
                    print(error.localizedDescription)
                } //: Switch
            } //: createNewMessage
        
        // cleaning Msg Field
        message = ""
    } //: Func
    
    var body: some View {
        
        let channel = listner.controller.channel!
        
        VStack {
            
           // ScrollView Reader for Scrolling down...
            ScrollViewReader { reader in
                ScrollView(.vertical, showsIndicators: false) {
                    
                    // Lazy Stack For Lazy Loading...
                    LazyVStack(alignment: .center, spacing: 15) {
                        
                        ForEach(listner.messages.reversed(), id: \.self) { msg in
                            MessageRowView(message: msg)
                        } //: Loop
                        
                    } //: L VS
                    .padding()
                    .padding(.bottom)
                    .id("MSG_VIEW")
                } //: Scroll
                .onChange(of: listner.messages, perform: { newValue in
                    withAnimation {
                        reader.scrollTo("MSG_VIEW", anchor: .bottom)
                    }
                }) //: onChange
                .onAppear {
                    // Scrolling to Bottom...
                    reader.scrollTo("MSG_VIEW", anchor: .bottom)
                } //: onApear
            } //: Scroll Reader
            
            // TextField and Send Buttton...
            HStack(spacing: 10) {
                TextField("Message", text: $message)
                    .modifier(ShadowModeifier())
                
                Button {
                    sendMessage()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .padding(10)
                        .background(Color.primary)
                        .foregroundColor(scheme == .dark ? .black : .white)
                        .clipShape(Circle())
                } //: Button
                // Disabling button when no txt typed...
                .disabled(message == "")
                .opacity(message == "" ? 0.5 : 1.0)
            } //: HS
            .padding(.horizontal)
            .padding(.bottom, 8)
        } //: VS
        .navigationTitle(channel.cid.id)
    }
}


