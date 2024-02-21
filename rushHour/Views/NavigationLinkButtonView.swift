//
//  NavigationLinkButtonView.swift
//  rushHour
//
//  Created by Maza, Joshua on 2/5/24.
//

import SwiftUI

struct NavigationLinkButtonView: View {

    let title: String
    let destination: Screens
    var action: () -> Void = {}
    
    var body: some View {
        NavigationLink(value: destination) {
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
        }
        .buttonStyle(.plain)
        .simultaneousGesture(TapGesture().onEnded{
            self.action()
        })
    }
}

#Preview {
    NavigationLinkButtonView(title: "", destination: .story)
}
