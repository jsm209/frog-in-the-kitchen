//
//  StoryBeatChoice.swift
//  rushHour
//
//  Created by Maza, Joshua on 1/30/24.
//

import Foundation

struct StoryBeatChoice: Codable, Hashable {
    var title: String
    var results: [StoryBeatChoiceResultCheck]
}
