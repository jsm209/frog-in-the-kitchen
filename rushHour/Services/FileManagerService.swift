//
//  FileManagerService.swift
//  rushHour
//
//  Created by Maza, Joshua on 2/2/24.
//

import Foundation

protocol FileManagerServiceProtocol {
    func savePlayerInfo(info: PlayerInfo, updateCache: Bool) throws
    func loadPlayerInfo() throws -> PlayerInfo?
}

public enum FileManagerServiceErrors: Equatable, Error {
    case unableToAccessDirectory
    case failedToEncodeData
    case failedToRetrieveData
}

class GameDataStorageService: FileManagerServiceProtocol {

    

    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let cache = PlayerInfoCacheService()
    
    private func getFileURL() throws -> URL {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileManagerServiceErrors.unableToAccessDirectory
        }
        
        // TODO: make this configuarable such that file manager can handle storing multiple files besides player data (fine for now)
        return documentsDirectory.appendingPathComponent(Constants.fileManagerPathPlayerInfo)
    }
    
    func savePlayerInfo(info: PlayerInfo, updateCache: Bool) throws {
        do {
            let fileURL = try getFileURL()
            let data = try encoder.encode(info)
            try data.write(to: fileURL)
            
            // successfully saved to file, so update the cache
            try cache.cachePlayerInfo(info: info)
        } catch {
            throw FileManagerServiceErrors.failedToEncodeData
        }
    }
    
    func loadPlayerInfo() throws -> PlayerInfo? {
        do {
            let fileURL = try getFileURL()
            if FileManager.default.fileExists(atPath: fileURL.path) {
                let storedResponse = try Data(contentsOf: fileURL)
                let collection = try decoder.decode(PlayerInfo.self, from: storedResponse)
                return collection
            }
        } catch {
            throw FileManagerServiceErrors.failedToRetrieveData
        }
        return nil
    }
}
