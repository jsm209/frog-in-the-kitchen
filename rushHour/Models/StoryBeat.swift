//
//  StoryBeat.swift
//  rushHour
//
//  Created by Maza, Joshua on 1/30/24.
//

import Foundation

struct StoryBeat: Codable {
    var title: String
    var content: String
    var prompt: String?
    var minCheckType: String?
    var choices: [StoryBeatChoice]?
}
