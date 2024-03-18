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
        
        do {
            playerInfo = try gameDataService.loadPlayerInfo()
        } catch {
            // TODO: Handle error
        }
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
    
    func displayResultAlert(title: String) {
        self.showAlert = true
        self.showAlertTitle = title
    }
    
    
    // Given the possible results, will dice roll a result for the player and select the highest possible result.
    // Assumes that results with higher minChecks are "better".
    // Assumes that the choiceResults are not empty.
    // If choiceResults only has one item, will default to that item and skip the dice roll.
    func getResultMessage(choiceResults: [StoryBeatChoiceResultCheck]?) -> String {
        guard let choiceResults else {
            return Constants.Labels.defaultResultMessage
        }
        if choiceResults.count == 1 {
            return choiceResults.first?.message ?? Constants.Labels.defaultResultMessage
        } else {
            var highestResult: StoryBeatChoiceResultCheck?
            let roll = doPlayerRoll()
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
            // TODO: write this in a better way instead of all these optionals
            selectedStoryChoiceResultStoryId = highestResult?.storyId ?? 0
            return highestResult?.message ?? Constants.Labels.defaultResultMessage
        }
    }
    
    
    // TODO: Make this function do two things, calculate the roll and determine the result, and update the result message and choice ID isntead of doing it all in getResultMessage
    // When a story choice is tapped, it should be sele
    func onStoryChoiceTap() {
        
    }
    
    // Rolls a 20 sided dice on a player's stat, returning a result plus or minus a modifier.
    func doPlayerRoll() -> Int {
        return 10
    }
}
