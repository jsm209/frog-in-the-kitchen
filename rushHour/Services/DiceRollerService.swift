//
//  DiceRollerService.swift
//  rushHour
//
//  Created by Maza, Joshua on 2/7/24.
//

import Foundation

class DiceRollService: ObservableObject {

    func rollDice(sides: Int = 20, mod: Int = 0) -> Int {
        let roll = Int(arc4random_uniform(20)) + 1 + mod
        return roll
    }

    func doCheck(mod: Int = 0, pass: Int = 10) -> Bool {
        let roll = rollDice(mod: mod)
        return roll >= pass
    }

}
