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
    var selectedStoryChoice: Int = 0
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
}
