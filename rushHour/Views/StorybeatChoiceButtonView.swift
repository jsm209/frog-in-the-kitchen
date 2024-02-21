//
//  StorybeatChoice.swift
//  rushHour
//
//  Created by Maza, Joshua on 1/29/24.
//

import SwiftUI

struct StorybeatChoiceButtonView: View {
    
    let title: String
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: {
            self.action()
        }, label: {
            HStack {
                Spacer()
                Text(title)
                    .padding(20)
                Spacer()
            }
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .strokeBorder(.black)
            )
            .padding(.leading, 25)
            .padding(.trailing, 25)
        })
        .buttonStyle(.plain)
    }
}

#Preview {
    StorybeatChoiceButtonView(title: "Jump over the lazy brown dog.")
}
