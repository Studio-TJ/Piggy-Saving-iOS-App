//
//  SavingListDaysView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 09/02/2022.
//

import SwiftUI

struct SavingListDaysView: View {
    @Binding var listItemHasChange: Bool
    let externalURL: String
    var savings: [Saving] = []
    var costs: [Saving] = []
    var displayOption = "Saving"
    var body: some View {
        List {
            ForEach(savings) { saving in
                SavingListItemView(externalURL: externalURL, itemUpdated: $listItemHasChange, saving: saving)
            }
            .listRowBackground(Color.clear)
        }
    }
}

struct SavingListDaysView_Previews: PreviewProvider {
    static var previews: some View {
        let listItemHasChange = false
        let externalURL = ""
        let savingsSample = Saving.sampleData1
        SavingListDaysView(listItemHasChange: .constant(listItemHasChange), externalURL: externalURL, savings: savingsSample)
            .previewLayout(.sizeThatFits)
    }
}
