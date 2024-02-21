//
//  Screens.swift
//  rushHour
//
//  Created by Maza, Joshua on 2/2/24.
//

import Foundation

indirect enum Screens: Codable, Hashable {
    case options
    case story
    case nameEntry(destination: Screens)
    case title
}
