//
//  ChannelView.swift
//  ChatStreamApp
//
//  Created by 1 on 31/10/21.
//

import SwiftUI
import StreamChat
import Firebase

struct ChannelView: View {
    
    @EnvironmentObject var streamData : StreamViewModel
    @AppStorage("userName") var storedUser = ""
    @AppStorage("log_Status") var logStatus = false
    
    var body: some View {
        
        // Channel View...
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(spacing: 20) {
                if let channels = streamData.channels {
                    ForEach(channels, id: \.channel) { listner in
                        NavigationLink {
                            ChatView(listner: listner)
                        } label: {
                            ChannelRowView(listner: listner)
                        }

                    }
                } else {
                    // Progress View
                    ProgressView()
                        .padding(.top, 20)
                }
            } //: VS
            .padding()
        } //: Scroll

        .navigationTitle("Channel")
        
        // Navigation Bar Buttons...
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    streamData.channels = nil
                    streamData.fetchingAllChannels() // <---------
                } label: {
                    Image(systemName: "arrow.clockwise.circle.fill")
                }
            } //: circle
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation {
                        streamData.createNewChannel.toggle()
                    }
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            } //: pencil
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    // Logging out...
                    logStatus = false
                    storedUser = ""
                    try! Auth.auth().signOut()
                } label: {
                    Image(systemName: "power")
                }
            } //: pencil
        } //: toolBar
        
        .onAppear {
            streamData.fetchingAllChannels() // <---------
        } //: onAppear
        
    }
}

struct ChannelRowView: View {
    
    @StateObject var listner: ChatChannelController.ObservableObject
    
    @EnvironmentObject var streamData: StreamViewModel
    
    // cheking if msg is from today then display time else display date...
    func checkIsDateToday(date: Date) -> Bool { //: IS
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) { // IN
            return true
        } else {
            return false
        }
    } //: Func
    
    func sortChannels() {
        let result = streamData.channels.sorted { (ch1, ch2) -> Bool in
            if let data1 = ch1.channel?.latestMessages.first?.createdAt {
                if let date2 = ch2.channel?.latestMessages.first?.createdAt {
                    return data1 > date2
                } //: ch2
                else {
                    return false
                }
            } //: ch1
            else {
                return false
            }
        } //: sorting
        streamData.channels = result
    } //: Func
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 5) {
            HStack(spacing: 12) {
                let channel = listner.controller.channel!
                
                Circle()
                    .fill(Color.gray.opacity(0.4))
                    .frame(width: 55, height: 55)
                    .overlay(
                    // First Letter as Image...
                        Text("\(String(channel.cid.id.first!))")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    ) //: overlay
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(channel.cid.id)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    if let lastMsg = channel.latestMessages.first {
                        // showing last user name...
                        (
                            Text(lastMsg.isSentByCurrentUser ? "Me " : "\(lastMsg.author.id)")
                            +
                            Text(lastMsg.text)
                        )
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                            
                    } //: last MSG
                } //: VS
                
                Spacer()
                // Time
                if let time = channel.latestMessages.first?.createdAt {
                    Text(time, style: checkIsDateToday(date: time) ? .time : .date)
                        .font(.caption2)
                        .foregroundColor(.gray)
                } //: last TIME
                
            } //: HS
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
                .padding(.leading, 60)
        } //: VS
        .onAppear {
            // watching the updates on channel...
            listner.controller.synchronize()
        } //: onApear
        .onChange(of: listner.controller.channel?.latestMessages.first?.text) { newValue in
            // firing sort...
            print("Sort Channels...")
            sortChannels()
        }

    }
}

struct ChannelView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelView()
    }
}
