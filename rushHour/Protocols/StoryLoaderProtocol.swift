//
//  StoryLoaderProtocol.swift
//  rushHour
//
//  Created by Maza, Joshua on 1/30/24.
//

import Foundation

protocol StoryLoaderProtocol {
    func getStories() async throws -> Stories
}
