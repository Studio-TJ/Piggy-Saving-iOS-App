//
//  GoalSettingSetEndDateView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 06/02/2022.
//

import SwiftUI

struct GoalSettingSetEndDateView: View {
    enum LengthChoice: Int, CaseIterable, Identifiable {
        case oneMonth
        case twoMonth
        case oneQuarter
        case halfYear
        case oneYear
        case custom
        
        var id: Int {
            self.rawValue
        }
        
        var caseDisplayName: String {
            switch self {
            case.oneMonth: return NSLocalizedString("After one month", comment: "After one month")
            case.twoMonth: return NSLocalizedString("After two months", comment: "After two months")
            case.oneQuarter: return NSLocalizedString("After one quarter", comment: "After one quarter")
            case.halfYear: return NSLocalizedString("After half year", comment: "After half year")
            case.oneYear: return NSLocalizedString("After one year", comment: "After one year")
            case.custom: return NSLocalizedString("Custom end date", comment: "Custom end date")
            }
        }
        
        var dateByCase: Date {
            switch self {
            case.oneMonth: return Calendar.current.date(byAdding: .month, value: 1, to: Date())!
            case.twoMonth: return Calendar.current.date(byAdding: .month, value: 2, to: Date())!
            case.oneQuarter: return Calendar.current.date(byAdding: .month, value: 3, to: Date())!
            case.halfYear: return Calendar.current.date(byAdding: .month, value: 6, to: Date())!
            case.oneYear: return Calendar.current.date(byAdding: .year, value: 1, to: Date())!
            case.custom: return Date()
            }
        }
    }
    @ObservedObject var configs: ConfigStore
    @State var endDateChoice: Int = LengthChoice.oneMonth.rawValue
    
    var body: some View {
        VStack {
            HStack {
                Text("Choose end date")
                Spacer()
                Picker("Choose end date", selection: $endDateChoice) {
                    ForEach(LengthChoice.allCases) { length in
                        Text(length.caseDisplayName).tag(length.id)
                    }
                }
                .pickerStyle(.menu)
            }
            .onChange(of: endDateChoice) { value in
                configs.configs.endDate = LengthChoice(rawValue: value)!.dateByCase
            }
            if endDateChoice == LengthChoice.custom.rawValue {
                DatePicker(
                    "Set End Date",
                    selection: $configs.configs.endDate ?? Date(),
                    displayedComponents: .date)
            }
            HStack {
                VStack(alignment:. leading) {
                    Text("End Date")
                    Text(configs.configs.endDate ?? Date(), style: .date)
                }
                Spacer()
            }
        }
    }
}

struct GoalSettingSetEndDateView_Previews: PreviewProvider {
    static var previews: some View {
        let configConst = ConfigStore(currency: "CNY")
        GoalSettingSetEndDateView(configs: configConst)
            .previewLayout(.sizeThatFits)
    }
}
