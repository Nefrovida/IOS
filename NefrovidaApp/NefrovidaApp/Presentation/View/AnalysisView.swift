//
//  AnalysisView.swift
//  NefrovidaApp
//
//  Created by Leonardo Cervantes on 17/11/25.
//

import SwiftUI

struct AnalysisView: View {
    var body: some View {
        VStack {
            Text("Análisis")
                .font(.largeTitle)
            Spacer()
            Text("Aquí irán los análisis médicos.")
                .foregroundColor(.secondary)
            Spacer()
        }
    }
}

#Preview {
    AnalysisView()
}