//
//  ProgressBarView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 14/02/2022.
//

import SwiftUI

struct ProgressBarView: View {
    let actual: Double
    let total: Double
    var body: some View {
        HStack {
            ProgressView(value: actual, total: total)
                .progressViewStyle(.linear)
                .tint(Color("MainPink"))
                .scaleEffect(x: 1, y: 2)
        }
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarView(actual: 1000, total: 1500)
    }
}
