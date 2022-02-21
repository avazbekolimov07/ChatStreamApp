//
//  MessageRowView.swift
//  ChatStreamApp
//
//  Created by 1 on 31/10/21.
//

import SwiftUI
import StreamChat

struct MessageRowView: View {
    
    var message: ChatMessage
    
    var body: some View {
        
        HStack {
            if message.isSentByCurrentUser {
                Spacer()
            }
            
            
            
            HStack(alignment: .bottom, spacing: 10) {
                if !message.isSentByCurrentUser {
                    UserView(message: message)
                        .offset(y: 10.0)
                }
                
                // Msg With Chat Bubble...
                VStack(alignment: message.isSentByCurrentUser ? .trailing : .leading, spacing: 6, content: {
                    Text(message.text)
                    
                    Text(message.createdAt, style: .time)
                        .font(.caption)
                }) //: VS
                    .padding([.horizontal, .top])
                    .padding(.bottom, 8)
                // User Color
                    .background(message.isSentByCurrentUser ? Color.blue : Color.gray.opacity(0.4))
                    .clipShape(ChatBubbleShape(corners: message.isSentByCurrentUser ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight]))
                    .foregroundColor(message.isSentByCurrentUser ? .white : .primary)
                    .frame(width: UIScreen.main.bounds.width - 150, alignment: message.isSentByCurrentUser ? .trailing : .leading)
                
                if message.isSentByCurrentUser {
                    UserView(message: message)
                        .offset(y: 10.0)
                }
            } //: HS
                
            if !message.isSentByCurrentUser {
                Spacer()
            }
        } //: HS
    }
}


// User View
struct UserView: View {
    var message: ChatMessage
    
    var body: some View {
        Circle()
            .fill(message.isSentByCurrentUser ? .blue : .gray.opacity(0.4))
            .frame(width: 40, height: 40)
            .overlay(
                // Auther First Latter...
                Text("\(String(message.author.id.first!))")
                    .fontWeight(.semibold)
                    .foregroundColor(message.isSentByCurrentUser ? .white : .primary)
            ) //: overlay
        
        // Contex Menu For Showing User Name and Last Active Status...
            .contextMenu {
                Text("\(message.author.id)")
                
                if message.author.isOnline {
                    Text("Status: Online")
                } else {
                    Text("\(message.author.lastActiveAt ?? Date(), style: .time)")
                }
            } //: contextMenu
        
    }
}
