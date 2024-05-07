//
//  StoryLoaderService.swift
//  rushHour
//
//  Created by Maza, Joshua on 1/30/24.
//

import Foundation

enum StoryLoaderServiceErrors: Error {
    case readError
    case dataError
    case decodingError
}

class StoryLoaderMockService: StoryLoaderProtocol {
    func getStories() async throws -> Stories {
        guard let url = Bundle.main.url(forResource: "stories",withExtension: "json") else {
            throw StoryLoaderServiceErrors.readError
        }

        guard let data = try? Data(contentsOf: url) else {
            throw StoryLoaderServiceErrors.dataError
        }

        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(Stories.self, from: data)
            return decodedData
        } catch {
            // TODO: When this error occurs, needs to be handled more gracefully by showing a message to the user
            throw StoryLoaderServiceErrors.decodingError
        }
    }
}
