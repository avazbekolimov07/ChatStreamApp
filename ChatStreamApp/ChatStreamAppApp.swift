//
//  ChatStreamAppApp.swift
//  ChatStreamApp
//
//  Created by 1 on 30/10/21.
//

import SwiftUI
import StreamChat
import Firebase
import JWTKit

@main
struct ChatStreamAppApp: App {
    
    // calling Delegate...
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// Delegate
class AppDelegate: NSObject, UIApplicationDelegate {
    
    // diffent way of initializing the Stream...
    
    @AppStorage("userName") var storedUser = ""
    @AppStorage("log_Status") var logStatus = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Intializing Firebase...
        FirebaseApp.configure()
        

        // if user already logged in...
        if logStatus {
            // Verifying if user is already in stream SDK or not...
            
            // for that we need to initialize the stream SDK with JWT Tokens...
            // AKA known as Authentication with Stream SDK...
            
            // generating JWT Token...
            let signers = JWTSigners()
            signers.use(.hs256(key: SecretKey.data(using: .utf8)!))
            
            // Creating Payload and inserting User ID to generete Token..
            // Here User ID will be Firebase UID...
            // Since it is unique...
            guard let uid = Auth.auth().currentUser?.uid else {
                return true
            }
            let payload = PayLoad(user_id: uid)
            
            // Generating Token...
            do {
                let jwt = try signers.sign(payload)
                print(jwt)
                
                let confic = ChatClientConfig(apiKeyString: APIKey)
                let tokenProvider =  TokenProvider.closure { client, completion in
                    guard let token = try? Token(rawValue: jwt) else  {
                        return
                    }
                    completion(.success(token))
                }
                
                ChatClient.shared = ChatClient(config: confic, tokenProvider: tokenProvider)
                
            } catch {
                print(error.localizedDescription)
            }
        } // : if
        
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
    
} //: Class

extension ChatClient{
    static var shared: ChatClient!
}
