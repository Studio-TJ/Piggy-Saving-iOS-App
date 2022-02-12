//
//  SavingListYearView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 09/02/2022.
//

import SwiftUI

struct SavingListYearView: View {
    var savings: [[Saving]]
    let externalURL: String
    @Binding var savingMonthShowList: [String: Bool]
    
    @Binding var itemUpdated: Bool
    
    var year: String {
        savings[0][0].dateLocalizedYear
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(year)
                    .font(Fonts.TITLE_SEMIBOLD)
                Spacer()
                Text("Saving Record")
                    .font(Fonts.BODY_CHINESE_NORMAL)
            }
            .padding(.leading, 10)
            .padding(.trailing, 10)
            
            ForEach(savings, id: \.self) { monthSavings in
                SavingListMonthView(savings: monthSavings, showList: $savingMonthShowList, itemUpdated: $itemUpdated, externalURL: externalURL)
                if monthSavings != savings.last {
                    Divider()
                        .padding(.top, 5)
                }
            }
        }
    }
}

struct SavingListYearView_Previews: PreviewProvider {
    static var previews: some View {
        let savings = [Saving.sampleData1, Saving.sampleData2]
        VStack {
            SavingListYearView(savings: savings, externalURL: "", savingMonthShowList: .constant([:]), itemUpdated: .constant(false))
            Spacer()
        }
    }
}
