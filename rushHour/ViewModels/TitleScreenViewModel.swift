//
//  TitleScreenViewModel.swift
//  rushHour
//
//  Created by Maza, Joshua on 2/6/24.
//

import Foundation


class TitleScreenViewModel: ObservableObject {
    
    @Published var playerNameExists: Bool = false
    
    func onAppear(gameDataStorageService: GameDataStorageService) {
        do {
            let validPlayerData = try gameDataStorageService.loadPlayerInfo()
            if validPlayerData?.name != nil {
                playerNameExists = true
            }
        } catch {
            // TODO: handle error
            playerNameExists = false
        }
    }
    
}
