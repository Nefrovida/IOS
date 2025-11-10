//
//  Forum.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 09/11/25.
//
import SwiftUI

struct Analysis: View {
    var body: some View {
        VStack {
            Button(action: goToAnalysis) {
                VStack{
                    Label("",systemImage: "testtube.2")
                    Text("Análisis");
                }
            }.padding(10)
                .foregroundColor(.black)
                
        }
    }
    
    func goToAnalysis() {
        
    }
}

#Preview(){
    Analysis()
}




