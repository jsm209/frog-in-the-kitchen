//
//  OptionsScreenViewModel.swift
//  rushHour
//
//  Created by Maza, Joshua on 2/6/24.
//

import Foundation


class OptionsScreenViewModel: ObservableObject {
    
    @Published public var showConfirmationAlert: Bool = false
    @Published public var showResultAlert: Bool = false
    
    @Published public var resultAlertTitle: String = ""
    
    func resetProgressAcceptAction(gameDataStorageService: GameDataStorageService) {
        do {
            try gameDataStorageService.erasePlayerInfo()
            showResultAlert(title: Constants.Labels.OptionsScreen.progressResetSuccess)
        } catch let error as GameDataStorageServiceErrors {
            if error == .fileDoesNotExistAtPath {
                showResultAlert(title: Constants.Labels.OptionsScreen.progressResetNoProgressFailure)
            } else {
                showResultAlert(title: Constants.Labels.OptionsScreen.progressResetDefaultFailure)
            }
        } catch {
            showResultAlert(title: Constants.Labels.OptionsScreen.progressResetDefaultFailure)
        }
        
    }
    
    func resetProgressDeclineAction() {
        showConfirmationAlert = false
    }
    
    func resultAlertAction() {
        showResultAlert = false
    }
    
    func showResultAlert(title: String) {
        showConfirmationAlert = false
        resultAlertTitle = title
        showResultAlert = true
    }
}
