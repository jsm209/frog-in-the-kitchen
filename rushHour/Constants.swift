//
//  Constants.swift
//  rushHour
//
//  Created by Maza, Joshua on 2/2/24.
//

import Foundation

struct Constants {
    
    static let fileManagerPathPlayerInfo = "playerInfo.txt"
    static let frogWizardImageSource = "https://i.pinimg.com/originals/89/9b/52/899b52866238a0ae6e652574a9437569.jpg"
    
    static let defaultStoryId = 0
    static let defaultStoryBeatIndex = 0
    static let defaultPlayerName = "Frawg"
    static let defaultPlayerHealth = 3
    static let defaultPlayerFrogs = 0
    static let defaultPlayerSkiMod = 0
    static let defaultPlayerIntMod = 0
    static let defaultPlayerVigMod = 0
    
    struct Labels {
        static let continueButtonTitle = "Continue"
        
        struct OptionsScreen {
            static let resetProgressConfirmationTitle = "Are you sure you want to reset your progress?"
            static let progressResetSuccess = "Your progress has been reset."
            static let progressResetDefaultFailure = "Could not reset your progress, please try again later."
            static let progressResetNoProgressFailure = "Could not reset your progress because there is no progress to reset."
        }
        
        static let defaultResultMessage = "There are no results for this choice..."
    }
    
    struct ErrorMessages {
        static let failedToLoadPlayerData = "Error: The player data could not be loaded properly. Please quit and restart the game."
        static let failedToSavePlayerData = "Error: The player data could not be saved properly. Please quit and restart the game."
    }
    
}
