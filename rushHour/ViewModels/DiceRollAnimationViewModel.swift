//
//  DiceRollAnimationViewModel.swift
//  rushHour
//
//  Created by Maza, Joshua on 6/12/24.
//

import Foundation

class DiceRollAnimationViewModel: ObservableObject {
    
    @Published var diceNumber: Int = 0
    @Published var hasSkippedAnimation: Bool = false
    @Published var modifierText: String = ""
    @Published var showModifierText: Bool = false

    var finalResult: Int
    var modifier: Int?
    var checkType: Constants.CheckTypes?
    var callback: () -> Void
    
    private var currentRollCount = 0
    private var targetRollCount = 20
    
    private var showModifierWorkItem: DispatchWorkItem = DispatchWorkItem(block: {})
    private var showFinalResultWorkItem: DispatchWorkItem = DispatchWorkItem(block: {})
    
    init(finalResult: Int, modifier: Int? = nil, checkType: Constants.CheckTypes? = nil, callback: @escaping () -> Void = {}) {
        self.finalResult = finalResult
        self.modifier = modifier
        self.checkType = checkType
        self.showModifierText = false
        self.hasSkippedAnimation = false
        self.callback = callback
        self.modifierText = self.makeModifierText(modifier: modifier, checkType: checkType)
    }
    
    // Will show a dice roll animation in a dismissable modal popup.
    // It will iterate randomly rapidly through numbers 1-20 for a few seconds
    // before landing on an initial roll.
    // Then after a brief delay it will show the modifier amount,
    // and then after another brief delay it will apply it and
    // animate some emphasis to show the final result
    // if the player ever taps "OK" before the animation is done, then it will skip to
    // showing the final result.
    func viewAppeared() {
        // start the dice roll animation
        // call updateToRandomNumber() something like 20 times in succession after small short delays.
        let rollTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { rollTimer in
            self.updateToRandomNumber()
            self.currentRollCount += 1
            
            // if hasSkippedAnimation is true at any point or we reach the target rolls immediately break and continue the flow.
            if self.currentRollCount == self.targetRollCount || self.hasSkippedAnimation {
                // at the end of the animation, land on the number that is the final rolled result (excludes modifier)
                self.diceNumber = self.finalResult - (self.modifier ?? 0)
                rollTimer.invalidate()
            }
        }
        
        showModifierWorkItem = DispatchWorkItem {
            self.showModifierText = true
            rollTimer.invalidate()
        }

        showFinalResultWorkItem = DispatchWorkItem {
            rollTimer.invalidate()
            self.showModifierText = false
            self.diceNumber = self.finalResult
        }
       
        // after this is done, have another brief delay then show some text like "+1 STR modifer" ONLY if hasSkippedAnimation is false.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: showModifierWorkItem)
        
        // and then have another brief delay before showing the final result
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: showFinalResultWorkItem)
        
    }
    
    func updateToRandomNumber() {
        // updates diceNumber to a random roll between 1-20
        diceNumber = Int.random(in: 1...20)
    }
    
    func makeModifierText(modifier: Int?, checkType: Constants.CheckTypes?) -> String {
        if let validModifier = modifier {
            if validModifier == 0 {
                return ""
            }
            if let validCheckType = checkType {
                return "\(validModifier) \(validCheckType) Modifier"
            }
            return validModifier > 0 ? "+\(validModifier) Modifier" : "-\(validModifier) Modifier"
        }
        return ""
    }
    
    // when OK is tapped while animation is running, we should skip to showing the final result
    // when OK is taped while the final result is shown, the callback should be called
    func onTapOK() {
        if !hasSkippedAnimation {
            showModifierWorkItem.cancel()
            showFinalResultWorkItem.cancel()
            showFinalResultWorkItem.perform()
            hasSkippedAnimation = true
        } else {
            callback()
        }
        
    }
}
