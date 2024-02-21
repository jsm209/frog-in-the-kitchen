//
//  FileManagerService.swift
//  rushHour
//
//  Created by Maza, Joshua on 2/2/24.
//

import Foundation

protocol GameDataStorageServiceProtocol {
    func savePlayerInfo(info: PlayerInfo, updateCache: Bool) throws
    func loadPlayerInfo() throws -> PlayerInfo?
    func erasePlayerInfo() throws
}

public enum GameDataStorageServiceErrors: Equatable, Error {
    case unableToAccessDirectory
    case failedToEncodeData
    case failedToRetrieveData
    case failedToDeleteData
    case fileDoesNotExistAtPath
}

// Will store game data to the file system for persistent storage and retrival
class GameDataStorageService: ObservableObject, GameDataStorageServiceProtocol {

    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let cache = PlayerInfoCacheService()
    
    private func getFileURL() throws -> URL {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw GameDataStorageServiceErrors.unableToAccessDirectory
        }
        
        // TODO: make this configuarable such that file manager can handle storing multiple files besides player data (fine for now)
        return documentsDirectory.appendingPathComponent(Constants.fileManagerPathPlayerInfo)
    }
    
    private func deleteFile(at fileURL: URL) throws {
        let fileManager = FileManager.default
        
        // Check if the file exists before attempting to delete
        if fileManager.fileExists(atPath: fileURL.path) {
            try fileManager.removeItem(at: fileURL)
            print("File deleted successfully")
        } else {
            print("File does not exist at path: \(fileURL.path)")
            throw GameDataStorageServiceErrors.fileDoesNotExistAtPath
        }
    }
    
    func savePlayerInfo(info: PlayerInfo, updateCache: Bool) throws {
        do {
            let fileURL = try getFileURL()
            let data = try encoder.encode(info)
            try data.write(to: fileURL)
            
            // successfully saved to file, so update the cache
            try cache.cachePlayerInfo(info: info)
        } catch {
            throw GameDataStorageServiceErrors.failedToEncodeData
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
            throw GameDataStorageServiceErrors.failedToRetrieveData
        }
        return nil
    }
    
    func erasePlayerInfo() throws {
        do {
            let fileURL = try getFileURL()
            try deleteFile(at: fileURL)
            
            // successfully erased, so update the cache
            cache.clearCache()
        } catch let error as GameDataStorageServiceErrors  {
            throw error
        } catch {
            print("Error deleting file: \(error.localizedDescription)")
            throw GameDataStorageServiceErrors.failedToDeleteData
        }
    }
}



