//
//  NameEntryView.swift
//  rushHour
//
//  Created by Maza, Joshua on 2/2/24.
//

import SwiftUI

struct NameEntryView: View {
    
    @ObservedObject var viewModel = NameEntryViewModel()
    
    // Where to go after finishing valid name entry
    var destination: Screens
    
    var body: some View {
        VStack (alignment: .center) {
            Spacer()
            Text("Hello young frawg, what is your name?")
                .italic()
            TextField("Name", text: $viewModel.playerName)
                .frame(width: 300)
            Spacer()
            NavigationLinkButtonView(
                title: "Continue",
                destination: destination,
                action: {
                    viewModel.saveName()
                }
            )
            .disabled(viewModel.playerName.isEmpty)
            .foregroundStyle(.black)
        }
    }
}

#Preview {
    NameEntryView(destination: .story)
}
