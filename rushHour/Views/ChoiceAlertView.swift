//
//  ChoiceAlertView.swift
//  rushHour
//
//  Created by Maza, Joshua on 2/6/24.
//

import SwiftUI

struct ChoiceAlertView: View {
    
    @ObservedObject var viewModel = AlertViewModel()
    
    let title: String
    var acceptAction: () -> Void = {}
    var declineAction: () -> Void = {}

    var body: some View {
        VStack {
            if let validImageData = viewModel.imageData {
                Image(uiImage: validImageData)
                    .resizable()
                    .scaledToFit()
            }
            HStack {
                Spacer()
                Text(title)
                    .padding(20)
                Spacer()
            }
            HStack {
                Button(action: {
                    self.acceptAction()
                }, label: {
                    HStack {
                        Spacer()
                        Text("YES")
                            .padding(5)
                        Spacer()
                    }
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .strokeBorder(.black)
                    )
                    .frame(width: 100)
                })
                .buttonStyle(.plain)
                .padding(.bottom, 15)
                .padding(.leading, 30)
                Spacer()
                Button(action: {
                    self.declineAction()
                }, label: {
                    HStack {
                        Spacer()
                        Text("NO")
                            .padding(5)
                        Spacer()
                    }
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .strokeBorder(.black)
                    )
                    .frame(width: 100)
                })
                .buttonStyle(.plain)
                .padding(.bottom, 15)
                .padding(.trailing, 30)
            }

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
    ChoiceAlertView(title: "I bet you didn't even know what poi was or how to eat it. Anyways you slurp down the taro paste immediately without second thought.")
}

