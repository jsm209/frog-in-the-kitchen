//
//  ContentView.swift
//  rushHour
//
//  Created by Maza, Joshua on 1/29/24.
//

import SwiftUI

class PathManager: ObservableObject {
    
    @Published public var path: [Screens] = []
    
    public func emptyPath() {
        self.path = []
    }
    
    public func pushPath(screen: Screens) {
        self.path.append(screen)
    }
    
}

struct ContentView: View {

    // Created services once here for dependency injection
    @ObservedObject var pathManager = PathManager()
    @ObservedObject var gameDataStorageService = GameDataStorageService()
    @ObservedObject var diceRollService = DiceRollService()

    var body: some View {
        NavigationStack(path: $pathManager.path) {
            TitleScreenView().navigationDestination(for: Screens.self) { screen in
                switch(screen) {
                case .options:
                    OptionsScreenView()
                case .story:
                    StoryView()
                case let .nameEntry(destination):
                    NameEntryView(destination: destination)
                case .title:
                    TitleScreenView()
                }
            }
            .onChange(of: pathManager.path) {
                print(pathManager.path)
            }
        }
        .environmentObject(pathManager)
        .environmentObject(gameDataStorageService)
        .environmentObject(diceRollService)
    }
}

#Preview {
    ContentView()
}
