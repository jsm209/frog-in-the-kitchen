//
//  Story.swift
//  rushHour
//
//  Created by Maza, Joshua on 1/30/24.
//

import Foundation

struct Story: Codable {
    var storyId: Int
    var beats: [StoryBeat]
}
