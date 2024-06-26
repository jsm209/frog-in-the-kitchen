//
//  PlayerInfo.swift
//  rushHour
//
//  Created by Maza, Joshua on 2/2/24.
//

import Foundation

struct PlayerInfo: Codable {
    var name: String
    var currentStoryId: Int
    var currentStoryBeatIndex: Int
    var frogs: Int
    var health: Int
    var skiMod: Int
    var intMod: Int
    var vigMod: Int
}
