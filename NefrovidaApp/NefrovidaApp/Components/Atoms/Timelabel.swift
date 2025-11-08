//
//  Timelabel.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 08/11/25.
//

// Components/Atoms/TimeLabel.swift
import SwiftUI

struct TimeLabel: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.subheadline)
            .frame(width: 48, alignment: .trailing)
            .foregroundStyle(.secondary)
    }
}
