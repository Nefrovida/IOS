//
//  UIApplication.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 25/11/25.
//

import SwiftUI

extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
