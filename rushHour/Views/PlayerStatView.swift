//
//  PlayerStatView.swift
//  rushHour
//
//  Created by Maza, Joshua on 4/17/24.
//

import SwiftUI

struct PlayerStatView: View {

    let label: String
    let value: String

    var body: some View {
        HStack {
            Text("\(label): ")
                .bold()
            Text(value)
            Spacer()
        }
        .font(.subheadline)
    }
}

#Preview {
    PlayerStatView(
        label: "",
        value: ""
    )
}
