//
//  StreamViewModel.swift
//  ChatStreamApp
//
//  Created by 1 on 30/10/21.
//

import SwiftUI
import StreamChat

class StreamViewModel: ObservableObject {
    
    @Published var userName = ""
    
    @AppStorage("userName") var storedUser = ""
    @AppStorage("log_Status") var logStatus = false
    
    // Alert...
    @Published var error = false
    @Published var errorMsg = ""
    
    // Loading Screen
    @Published var isLoading = false
    
    // New!!!
    // Channel Data
    @Published var channels: [ChatChannelController.ObservableObject]!
    
    // Create New Channel
    @Published var createNewChannel = false
    @Published var channelName = "" // = channel-id
    
    // New!!!!
    func logInUser() {
        // Logging In User...
        
        withAnimation{isLoading = true}
        
        // Updating User Profile...
        // You can give user image url...
        
        // Update User Profile...
        ChatClient.shared.currentUserController().updateUserData(name: userName, imageURL: nil, userExtraData: .defaultValue) { error in
                
                withAnimation {self.isLoading = false}
                
                if let error = error {
                    self.errorMsg = error.localizedDescription
                    self.error.toggle()
                    return
                }
                
                // Else Successful
                // Storing User Name...
                self.storedUser = self.userName
                self.logStatus = true
            
        }
        
        
    } //: Func
    
    // New!!!!
    // Fetching All Channels
    func fetchingAllChannels() {
        
        
        // filter...
        let filter = Filter<ChannelListFilterScope>.equal("type", to: "messaging")
        
        let request = ChatClient.shared.channelListController(query: .init(filter: filter))
        
        request.synchronize { error in
            if let error = error {
                self.errorMsg = error.localizedDescription
                self.error.toggle()
                return
            }
            
            // Else Successful
            self.channels = request.channels.compactMap({ channel -> ChatChannelController.ObservableObject? in
                return ChatClient.shared.channelController(for: channel.cid).observableObject
                })
            } //: request
        
    } //: Func
    
    // Creating New Channel
    func createChannel() {
        withAnimation {self.isLoading = true}
        
        let newChannel = ChannelId(type: .messaging, id: channelName)
        
        // you can give image url to channel
        // same you can alse give image url to user
        let request = try! ChatClient.shared.channelController(createChannelWithId: newChannel,
                                                          name: channelName,
                                                          imageURL: nil,
                                                          extraData: .defaultValue) // request
        
        request.synchronize { error in
            withAnimation {self.isLoading = false}
            
            if let error = error {
                self.errorMsg = error.localizedDescription
                self.error.toggle()
                return
            }
            // Else Successful
            // Closing Loading and New Channel View
            self.channelName = ""
            withAnimation {self.createNewChannel = false}
        } // request
    } //: Func
}


