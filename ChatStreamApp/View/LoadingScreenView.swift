//
//  LoadingScreenView.swift
//  ChatStreamApp
//
//  Created by 1 on 31/10/21.
//

import SwiftUI

struct LoadingScreenView: View {
    
    // changing based on ColorScheme
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Color.primary
                .opacity(0.2 )
                .ignoresSafeArea()
            
            ProgressView()
                .frame(width: 50, height: 50)
                .background(colorScheme != .dark ? Color.white : Color.black)
                .cornerRadius(8)
        } //: ZS
    }
}

struct LoadingScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreenView()
    }
}
