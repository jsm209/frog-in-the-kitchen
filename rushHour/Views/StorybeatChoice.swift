//
//  StorybeatChoice.swift
//  rushHour
//
//  Created by Maza, Joshua on 1/29/24.
//

import SwiftUI

struct StorybeatChoiceButtonView: View {
    var body: some View {
        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
            HStack {
                Spacer()
                Text("Jump over the lazy brown dog.")
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
    StorybeatChoiceButtonView()
}
