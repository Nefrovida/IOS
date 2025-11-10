//
//  Notification.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 10/11/25.
//

import SwiftUI

struct Notification: View {
    var body: some View {
        Button(action:goToNotification){
            Image(systemName: "bell")
        }.foregroundColor(.black)
    }
    func goToNotification(){
        
    }
}

#Preview {
    Notification()
}
