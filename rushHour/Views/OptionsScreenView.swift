//
//  OptionsScreenView.swift
//  rushHour
//
//  Created by Maza, Joshua on 2/2/24.
//

import SwiftUI

struct OptionsScreenView: View {
    
    @EnvironmentObject private var pathManager: PathManager
    @EnvironmentObject private var gameDataStorageService: GameDataStorageService
    
    @ObservedObject public var viewModel = OptionsScreenViewModel()
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Spacer()
                Text("Options")
                    .font(.title)
                Spacer()
                NavigationLinkButtonView(
                    title: "Change name",
                    destination: Screens.nameEntry(destination: .options)
                )
                StorybeatChoiceButtonView(title: "Change language") {
                    
                }
                StorybeatChoiceButtonView(title: "Reset progress") {
                    viewModel.showConfirmationAlert = true
                }
                Spacer()
                StorybeatChoiceButtonView(title: "Back to title") {
                    pathManager.emptyPath()
                }
            }
            .navigationBarBackButtonHidden(true)
            
            // Alert View
            if viewModel.showConfirmationAlert {
                ChoiceAlertView(
                    title: Constants.Labels.OptionsScreen.resetProgressConfirmationTitle,
                    acceptAction: {
                        viewModel.resetProgressAcceptAction(
                            gameDataStorageService: gameDataStorageService
                        )
                    },
                    declineAction: {
                        viewModel.resetProgressDeclineAction()
                    }
                )
            }
            
            if viewModel.showResultAlert {
                ResultAlertView(
                    title: viewModel.resultAlertTitle,
                    action: {
                        viewModel.resultAlertAction()
                    }
                )
            }
        }

    }
}

#Preview {
    OptionsScreenView()
}
