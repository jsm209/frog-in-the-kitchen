//
//  StoryView.swift
//  rushHour
//
//  Created by Maza, Joshua on 1/29/24.
//

import SwiftUI

struct StoryView: View {
    
    @ObservedObject var viewModel = StoryViewViewModel()
    
    @EnvironmentObject private var pathManager: PathManager
    
    var body: some View {
        ZStack {
            VStack {
                StorybeatChoiceButtonView(title: "Back To Title") {
                    pathManager.emptyPath()
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text(viewModel.currentStoryBeat?.title ?? "")
                            .font(.title)
                        Text(viewModel.currentStoryBeat?.content ?? "")
                        Spacer()
                    }
                    //.frame(width: .infinity)
                    .padding(.top, 100)
                    .padding(.leading, 25)
                    .padding(.trailing, 25)
                    Spacer()
                }
                Spacer()
                VStack {
                    if let currentStoryBeatChoices = viewModel.currentStoryBeat?.choices {
                        Text(viewModel.currentStoryBeat?.prompt ?? "")
                        ForEach(currentStoryBeatChoices, id: \.self) { choice in
                            StorybeatChoiceButtonView(title: choice.title) {
                                viewModel.displayResultAlert(title: choice.result)
                                viewModel.selectedStoryChoice = choice.storyId
                            }
                        }
                    } else {
                        StorybeatChoiceButtonView(title: Constants.Labels.continueButtonTitle) {
                            viewModel.nextStoryBeat()
                        }
                    }
                }
                .padding(.bottom, 25)
            }
            .onAppear {
                viewModel.viewAppeared()
            }
            if viewModel.showAlert {
                ResultAlertView(
                    title: viewModel.showAlertTitle.replacingOccurrences(
                        of: "{name}",
                        with: viewModel.playerInfo?.name ?? Constants.defaultPlayerName
                    )
                ) {
                    viewModel.showAlert = false
                    viewModel.nextStory(id: viewModel.selectedStoryChoice)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    StoryView()
}
