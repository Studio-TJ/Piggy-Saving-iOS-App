//
//  CostListItemView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 04/02/2022.
//

import SwiftUI

struct CostListItemView: View {
    let cost: Cost
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(cost.date)
                    .font(.headline)
                Spacer()
                Label(String(format: "%.2f", cost.amount), systemImage: "eurosign.circle")
                    .labelStyle(.trailingIcon)
            }
            Text(cost.description)
        }
    }
}

struct CostListItemView_Previews: PreviewProvider {
    static var previews: some View {
        let costConst = Cost()
        CostListItemView(cost: costConst)
            .previewLayout(.sizeThatFits)

    }
}
