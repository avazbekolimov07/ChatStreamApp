//
//  ChatBubbleShape.swift
//  ChatStreamApp
//
//  Created by 1 on 31/10/21.
//

import SwiftUI

struct ChatBubbleShape: Shape {
    
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: 13, height: 13))
        
        return Path(path.cgPath)
    }
}

