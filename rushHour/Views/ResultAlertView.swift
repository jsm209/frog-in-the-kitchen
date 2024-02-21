//
//  ResultAlertView.swift
//  rushHour
//
//  Created by Maza, Joshua on 1/30/24.
//

import SwiftUI

struct ResultAlertView: View {
    
    @ObservedObject var viewModel = AlertViewModel()
    
    let title: String
    var action: () -> Void = {}
    
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
            Button(action: {
                self.action()
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
    ResultAlertView(title: "I bet you didn't even know what poi was or how to eat it. Anyways you slurp down the taro paste immediately without second thought.")
}
