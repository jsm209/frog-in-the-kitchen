//
//  StoryBeatChoiceResultCheck.swift
//  rushHour
//
//  Created by Maza, Joshua on 3/18/24.
//

import Foundation

struct StoryBeatChoiceResult: Codable, Hashable {
    var minCheck: Int
    var message: String
    var healthChange: Int?
    var skiChange: Int?
    var intChange: Int?
    var vigChange: Int?
    var storyId: Int
}
