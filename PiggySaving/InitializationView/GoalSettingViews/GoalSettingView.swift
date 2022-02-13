//
//  GoalSettingView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 06/02/2022.
//

import SwiftUI

struct GoalSettingView: View {
    @FetchRequest(entity: Configs.entity(), sortDescriptors: []) var fetchedConfigs: FetchedResults<Configs>
    @Environment(\.managedObjectContext) var moc
    var preview: Bool = false
    
    @Binding var selectedItem: InitializationTabItem
    
    var configs: Configs {
        if preview {
            return ConfigStore().configs
        } else {
            return fetchedConfigs.first ?? Configs(context: moc)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Set your Goal")
                    .font(Fonts.TITLE_SEMIBOLD)
                    .padding(.top, 50)
                Spacer(minLength: 35)
            }
            GoalSettingSetMinimalUnitView(configs: configs)
                .padding(.top, 50)
            GoalSettingSetEndDateView(configs: configs)
            Divider()
            GoalSettingResultView(configs: configs)
            Spacer()
        }
        .frame(width: SCREEN_SIZE.width * 0.86)
        .onChange(of: selectedItem) { value in
            if value != InitializationTabItem.GOAL_SETTINGS {
                try? moc.save()
            }
        }
    }
}

struct GoalSettingView_Previews: PreviewProvider {
    static var previews: some View {
        GoalSettingView(preview: true, selectedItem: .constant(InitializationTabItem.GOAL_SETTINGS))
    }
}
