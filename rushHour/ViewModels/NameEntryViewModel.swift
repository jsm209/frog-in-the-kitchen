//
//  NameEntryViewModel.swift
//  rushHour
//
//  Created by Maza, Joshua on 2/5/24.
//

import Foundation

class NameEntryViewModel: ObservableObject {
    
    @Published public var playerName = ""
    
    let gameDataStorageService = GameDataStorageService()
    
    private var playerInfo: PlayerInfo?
    
    func getExistingPlayerInfo() -> PlayerInfo? {
        var currentPlayerInfo: PlayerInfo? = nil
        do {
            currentPlayerInfo = try gameDataStorageService.loadPlayerInfo()
        } catch {
            return nil
        }
        return currentPlayerInfo
    }
    
    func saveName() {
        // Attempt to get the playerInfo first if it exists and use that info
        // otherwise create new info
        var validCurrentPlayerInfo = getExistingPlayerInfo() ?? PlayerInfo(
            name: "",
            currentStoryId: Constants.defaultStoryId,
            currentStoryBeatIndex: Constants.defaultStoryBeatIndex
        )
        
        // Set the new name in either case that the old playerInfo existed or not
        validCurrentPlayerInfo.name = playerName
        
        do {
            try gameDataStorageService.savePlayerInfo(info: validCurrentPlayerInfo, updateCache: true)
        } catch {
            // TODO: handle error
        }
    }
    
}
