//
//  SavingListDaysView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 09/02/2022.
//

import SwiftUI

struct SavingListDaysView: View {
    @Binding var listItemHasChange: Bool
    @Binding var externalURL: String
    var savings: [Saving] = []
    var costs: [Cost] = []
    var displayOption = "Saving"
    var body: some View {
        List {
            if self.displayOption == "Saving" {
                ForEach(savings) { saving in
                    SavingListItemView(externalURL: $externalURL, itemUpdated: $listItemHasChange, saving: saving)
                }
                .listRowBackground(Color.clear)
            } else {
                ForEach(costs) { cost in
                    CostListItemView(cost: cost)
                }
                .listRowBackground(Color.clear)
            }
        }
    }
}

struct SavingListDaysView_Previews: PreviewProvider {
    static var previews: some View {
        let listItemHasChange = false
        let externalURL = ""
        let savingsSample = Saving.sampleData1
        SavingListDaysView(listItemHasChange: .constant(listItemHasChange), externalURL: .constant(externalURL), savings: savingsSample)
            .previewLayout(.sizeThatFits)
    }
}
