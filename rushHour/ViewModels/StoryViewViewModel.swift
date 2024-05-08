//
//  StoryViewViewModel.swift
//  rushHour
//
//  Created by Maza, Joshua on 1/30/24.
//

import Foundation

class StoryViewViewModel: ObservableObject {
    
    // Services
    let storyLoaderService = StoryLoaderMockService()
    let gameDataService = GameDataStorageService()
    let diceService = DiceRollService()
    
    // All the stories loaded by the service
    @Published var stories: [Story] = []
    
    // Current story objects
    @Published var currentStory: Story?
    @Published var currentStoryBeat: StoryBeat?
    
    // Tracks current place in story related collections (for progressing through them linearly)
    var currentStoryId: Int = 0
    var currentStoryBeatIndex: Int = 0
    
    // Alert related
    var selectedStoryChoiceResultStoryId: Int = 0
    @Published var showAlert: Bool = false
    @Published var showAlertTitle: String = ""
    
    // Player related
    @Published var playerInfo: PlayerInfo?

    func viewAppeared() {
        print("on view appeared")
        Task {
            await loadStories()
        }
        updatePlayerInfo()
    }
    
    @MainActor
    func loadStories() async {
        do {
            let myStories = try await storyLoaderService.getStories()
            stories = myStories.stories
            currentStory = stories.first
            initializeNextStory()
        } catch let error as StoryLoaderServiceErrors {
            print("loadStories() error")
            
            // TODO: switch over the possible errors, handle this error gracefully
            switch error {
            case .readError:
                print("loadStories() error readError")
            case .dataError:
                print("loadStories() error dataError")
            case .decodingError:
                print("loadStories() error decodingError")
            }
        } catch {
            print("loadStories() error unknown error")
        }
    }
    
    func initializeNextStory() {
        currentStoryBeat = currentStory?.beats.first
        currentStoryBeatIndex = 0
        updatePlayerInfo()
    }
    
    func nextStoryBeat() {
        currentStoryBeatIndex += 1
        if currentStoryBeatIndex < currentStory?.beats.count ?? 0 {
            currentStoryBeat = currentStory?.beats[currentStoryBeatIndex]
        }
    }
    
    func nextStory(id: Int) {
        if stories.indices.contains(id) {
            currentStory = stories[id]
            initializeNextStory()
        }
    }
    
    func displayAlert(title: String) {
        self.showAlert = true
        self.showAlertTitle = title
    }

    // TODO: Make the error alert visually distinct from the game story alerts.
    func displayErrorAlert(title: String) {
        self.showAlert = true
        self.showAlertTitle = title
    }

    // When a story choice is tapped, it should be select that choice and figure out the correct result.
    // Given the possible results, will dice roll a result for the player and select the highest possible result.
    // Assumes that results with higher minChecks are "better".
    // Assumes that the choiceResults are not empty.
    // If choiceResults only has one item, will default to that item and skip the dice roll.
    func onStoryChoiceTap(choiceResults: [StoryBeatChoiceResult]?) {
        guard let choiceResults else {
            // This will only occur if the data is malformed.
            displayAlert(title: Constants.Labels.defaultResultMessage)
            return
        }
        var finalResult: StoryBeatChoiceResult?
        if choiceResults.count == 1 {
            finalResult = choiceResults.first
        } else {
            var highestResult: StoryBeatChoiceResult?
            let roll = calculateRoll(minCheckType: currentStoryBeat?.minCheckType)

            for result in choiceResults {
                // if the roll is high enough for the result
                if roll >= result.minCheck {
                    // check to make sure it is a better result before replacing it
                    if let validHighestResult = highestResult {
                        if result.minCheck > validHighestResult.minCheck {
                            highestResult = result
                        }
                    } else {
                        // if this is the first valid result it automatically is the highest
                        highestResult = result
                    }
                }
            }
            finalResult =  highestResult
        }

        if let validFinalResult = finalResult {
            processFinalStoryResult(result: validFinalResult)
        } else {
            displayAlert(title: Constants.Labels.defaultResultMessage)
        }
    }
    
    // Given a result from making a choice
    // will update the selected result so the story can continue, display the appropriate alert,
    // and update any changes to the player data to the cache.
    func processFinalStoryResult(result: StoryBeatChoiceResult) {
        selectedStoryChoiceResultStoryId = result.storyId
        displayAlert(title: result.message)
        
        // If we already have valid player data, update it with stat changes, if any.
        if var validPlayerInfo = playerInfo {
            if let validFrogsChange = result.frogsChange {
                validPlayerInfo.frogs += validFrogsChange
            }

            if let validHealthChange = result.healthChange {
                validPlayerInfo.health += validHealthChange
            }

            if let validSkiChange = result.skiChange {
                validPlayerInfo.skiMod += validSkiChange
            }

            if let validIntChange = result.intChange {
                validPlayerInfo.intMod += validIntChange
            }

            if let validVigChange = result.vigChange {
                validPlayerInfo.vigMod += validVigChange
            }

            do {
                try gameDataService.savePlayerInfo(info: validPlayerInfo, updateCache: true)
            } catch {
                displayErrorAlert(title: Constants.ErrorMessages.failedToSavePlayerData)
            }
        }
    }

    func updatePlayerInfo() {
        do {
            playerInfo = try gameDataService.loadPlayerInfo()
        } catch {
            displayErrorAlert(title: Constants.ErrorMessages.failedToLoadPlayerData)
        }
    }
    
    // Rolls a 20 sided dice on a player's stat, returning a result plus or minus a modifier.
    // If the minCheckType is missing or not a valid type it will roll a regular 20 sided dice
    func calculateRoll(minCheckType: String?) -> Int {
        guard let minCheckType else {
            return diceService.rollDice()
        }
        switch minCheckType {
        case Constants.CheckTypes.SKI.rawValue:
            return diceService.rollDice(mod: playerInfo?.skiMod ?? 0)
        case Constants.CheckTypes.INT.rawValue:
            return diceService.rollDice(mod: playerInfo?.intMod ?? 0)
        case Constants.CheckTypes.VIG.rawValue:
            return diceService.rollDice(mod: playerInfo?.vigMod ?? 0)
        default:
            return diceService.rollDice()
        }
    }
}
