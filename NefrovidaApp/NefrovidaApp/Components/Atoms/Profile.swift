//
//  Profile.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 10/11/25.
//
import SwiftUI

struct Profile: View
{
    var body: some View {
        Button(action : goToProfile){
            Image(systemName: "person.crop.circle")
        }.foregroundColor(.black)
    }
    func goToProfile(){
        
    }
}

#Preview {
    Profile()
}
