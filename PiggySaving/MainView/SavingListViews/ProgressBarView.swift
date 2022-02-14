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
    let frontColor: Color
    let backgroundColor: Color
    
    var height:Double = 5
    
    var ratio: Double {
        return actual / total
    }
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundColor)
                .frame(height: height)
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(frontColor)
                        .scaleEffect(x: ratio, anchor: .leading)
                }
        }
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarView(actual: 1000, total: 1500, frontColor: Color.pink, backgroundColor: Color.gray)
    }
}
