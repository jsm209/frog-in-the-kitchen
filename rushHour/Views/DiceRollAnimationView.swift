//
//  DiceRollAnimationView.swift
//  rushHour
//
//  Created by Maza, Joshua on 6/12/24.
//

import SwiftUI

struct DiceRollAnimationView: View {
    
    @ObservedObject var viewModel: DiceRollAnimationViewModel
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                Text("\($viewModel.diceNumber.wrappedValue)")
                    .padding(20)
                if viewModel.showModifierText {
                    Text("\($viewModel.modifierText.wrappedValue)")
                        .padding(20)
                }
                Spacer()
            }
            Button(action: {
                self.viewModel.onTapOK() // should skip to dice roll result, and then after the result is showing, maybe have a separate button that will appear for closing the popup
            }, label: {
                HStack {
                    Spacer()
                    Text("OK")
                        .padding(5)
                    Spacer()
                }
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .strokeBorder(.black)
                )
                .frame(width: 200)
            })
            .buttonStyle(.plain)
            .padding(.bottom, 15)
        }
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .strokeBorder(.black)
        )
        .background(.white)
        .frame(width: 300, height: 450)
        .padding(.leading, 25)
        .padding(.trailing, 25)
        .onAppear {
            viewModel.viewAppeared()
        }
    }
}

#Preview {
    DiceRollAnimationView(viewModel: DiceRollAnimationViewModel(finalResult: 20, modifier: 2, checkType: Constants.CheckTypes.SKI))
}
