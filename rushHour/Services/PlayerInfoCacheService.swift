//
//  PlayerInfoCacheService.swift
//  rushHour
//
//  Created by Maza, Joshua on 2/2/24.
//

import Foundation

protocol PlayerInfoServiceProtocol {

    /// Insert the player info into the cache
    /// - Parameters:
    ///   - info: player info to be inserted
    func cachePlayerInfo(info: PlayerInfo) throws
    
    /// Gets the current player info from the cache
    /// - Returns: The current player info
    func getPlayerInfo() -> PlayerInfo?

}

class PlayerInfoCacheService: NSCacheStorageService, PlayerInfoServiceProtocol {

    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    func cachePlayerInfo(info: PlayerInfo) throws {
        let jsonData = try encoder.encode(info)
        if let jsonDataAsString = String(data: jsonData, encoding: .utf8) {
            self.insert(value: jsonDataAsString, forKey: "playerInfo")
        }
    }

    func getPlayerInfo() -> PlayerInfo? {
        if let cachedTodos = self.getValue(forKey: "playerInfo") {
            let data = Data((cachedTodos).utf8)
            do {
                let decodedResponse = try decoder.decode(PlayerInfo.self, from: data)
                return decodedResponse
            } catch {
                return nil
            }
        }
        return nil
    }
    
    func clearCache() {
        self.removeAll()
    }
}
