//
//  AvatarCircle.swift
//  NefrovidaApp
//
//  Created by Iván FV on 08/11/25.
//

import SwiftUI

struct AvatarCircle: View {
    var body: some View {
        ZStack {
            Circle().fill(Color(.tertiarySystemFill))
            Image(systemName: "person.fill")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Color(.secondaryLabel))
        }
        .frame(width: 52, height: 52)
    }
}
