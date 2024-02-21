//
//  TitleScreenView.swift
//  rushHour
//
//  Created by Maza, Joshua on 2/2/24.
//

import SwiftUI

struct TitleScreenView: View {
    
    @ObservedObject var viewModel = TitleScreenViewModel()
    
    @EnvironmentObject private var gameDataStorageService: GameDataStorageService
    
    var body: some View {
        VStack (alignment: .center) {
            Spacer()
            Text("Frog In The Kitchen")
                .font(.largeTitle)
            Text("A silly text based interactive story fiction game about being a frog surviving in a restaurant kitchen in Paris.")
                .padding()
                .multilineTextAlignment(.center)
            Spacer()
            Group {
                // If the player doesn't have a name yet, take them to the name entry screen.
                if viewModel.playerNameExists {
                    NavigationLinkButtonView(
                        title: "Start",
                        destination: .story
                    )
                } else {
                    NavigationLinkButtonView(
                        title: "Start",
                        destination: .nameEntry(destination: .story)
                    )
                }
               
                NavigationLinkButtonView(
                    title: "Options",
                    destination: .options
                )
            }
            .foregroundStyle(.black)
        }
        .onAppear {
            viewModel.onAppear(gameDataStorageService: gameDataStorageService)
        }
    }
}

#Preview {
    TitleScreenView()
}
