//
//  LoginViewModel.swift
//  ChatStreamApp
//
//  Created by 1 on 05/11/21.
//

import SwiftUI
import Firebase
import StreamChat
import JWTKit

class LoginViewModel: ObservableObject {
    
    // Login Properties...
    @Published var countryCode = ""
    @Published var phoneNum = ""
    
    // Alert...
    @Published var showAlert = false
    @Published var errorMsg = ""
    
    // Verification ID
    @Published var ID = ""
    
    // Loading...
    @Published var isLoading = false
    
    @AppStorage("userName") var storedUser = ""
    @AppStorage("log_Status") var logStatus = false
    @Published var newUser = false
    
    
    func verifyUser() {
        
//         Undo this if testing with real devices or real phone Numbers...
//        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        
        withAnimation {
            isLoading = true
        }
        
        // Sending Opt and Verifying user...
        PhoneAuthProvider.provider().verifyPhoneNumber("+\(countryCode + phoneNum)", uiDelegate: nil) { ID, error in 
            
            if let error = error {
                self.errorMsg = error.localizedDescription
                self.showAlert.toggle()
                return
            }
            self.ID = ID!
            self.alertWithTF()
            
        }
    } //: FUNC
    
    // Alert With TextField For OPT Code...
    func alertWithTF() {
        let alert = UIAlertController(title: "Verification", message: "Enter OPT Code", preferredStyle: .alert)
        
        alert.addTextField { txt in
            txt.placeholder = "123456"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let code = alert.textFields?[0].text {
                self.loginUser(forCode: code)
            } else {
                self.reportError()
            }
        }))
        
        // Presenting Alert View...
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
        
    } //: FUNC
    
    // Logging in User
    func loginUser(forCode: String) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.ID, verificationCode: forCode)
        
        let verificationID = UserDefaults.standard.string(forKey: forCode)
        let setVerificationID = UserDefaults.standard.set(verificationID, forKey: forCode)
        Auth.auth().signIn(with: credential) { result, error in
            if let error = error {
                self.errorMsg = error.localizedDescription
                self.showAlert.toggle()
                return
            }
            
            // user Successfully Logged In...
            print("success")
            
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
                self.reportError()
                return 
            }
            let payload = PayLoad(user_id: uid)
            
            // Generating Token...
            do {
                let jwt = try signers.sign(payload)
                print(jwt)
                
                let confic = ChatClientConfig(apiKeyString: APIKey)
                let tokenProvider =  TokenProvider.closure { client, completion in
                    guard let token = try? Token(rawValue: jwt) else  {
                        self.reportError()
                        return
                    }
                    completion(.success(token))
                }
                
                ChatClient.shared = ChatClient(config: confic, tokenProvider: tokenProvider)
                
                // Reloading ChatClient...
                ChatClient.shared.currentUserController().reloadUserIfNeeded { error in
                    if let _ = error {
                        self.reportError()
                        return
                    }

                    // Simple Trick to find the user is already signed up...
                    // Just Checking the user having name...
                    // if yes then it means the user aleardy signed up...
                    // else new user...

                    if let name = ChatClient.shared.currentUserController().currentUser?.name {
                        withAnimation {
                            self.storedUser = name
                            self.logStatus = true
                            self.isLoading = false
                        }
                    } else {
                        withAnimation {
                            self.newUser = true
                            self.isLoading = false
                        }
                    }

                } //: RELOAD
            } catch {
                print(error.localizedDescription)
                self.reportError()
            }
            
            
            
        } // :Sign in
    } //: FUNC
    
    // Reporting Error...
    func reportError() {
        self.errorMsg = "Please try again later!"
        self.showAlert.toggle()
    } //: FUNC
} //: Class

struct PayLoad: JWTPayload, Equatable {
    
    enum CodingKeys: String, CodingKey {
        case user_id
    }
    
    var user_id: String
    
    func verify(using signer: JWTSigner) throws {
        
    }
} //: Struct



