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
                VStack {
                    HStack {
                        PlayerStatView(label: "Name", value: viewModel.playerInfo?.name ?? "")
                        PlayerStatView(label: "HP", value: "\(viewModel.playerInfo?.health ?? 0)")
                    }
                    PlayerStatView(label: "Frogs in the kitchen", value: "\(viewModel.playerInfo?.frogs ?? 0)")
                    HStack {
                        PlayerStatView(label: "SKI", value: "\(viewModel.playerInfo?.skiMod ?? 0)")
                        PlayerStatView(label: "INT", value: "\(viewModel.playerInfo?.intMod ?? 0)")
                        PlayerStatView(label: "VIG", value: "\(viewModel.playerInfo?.vigMod ?? 0)")
                    }
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
                                viewModel.onStoryChoiceTap(choiceResults: choice.results)
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
                    viewModel.nextStory(id: viewModel.selectedStoryChoiceResultStoryId)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    StoryView()
}
