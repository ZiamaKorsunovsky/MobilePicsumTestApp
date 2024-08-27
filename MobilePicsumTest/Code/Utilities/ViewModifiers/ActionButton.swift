//
//  ActionButton.swift
//  MobilePicsumTest
//
//  Created by Artiom Rastegaev on 2024-08-27.
//

import SwiftUI

struct ActionButton: ViewModifier {
    var color: Color = Color.red

    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .bold, design: .default))
            .frame(maxWidth: .infinity, maxHeight: 60)
            .foregroundColor(Color.white)
            .background(color)
            .cornerRadius(10)
            .padding()
    }
}
