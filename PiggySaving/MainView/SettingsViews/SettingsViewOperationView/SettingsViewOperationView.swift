//
//  SettingsViewOperationSettings.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 12/02/2022.
//

import SwiftUI

struct SettingsViewOperationView: View {
    @FetchRequest(entity: Configs.entity(), sortDescriptors: []) var fetchedConfigs: FetchedResults<Configs>
    @Environment(\.managedObjectContext) var moc
    @Environment(\.isPreview) var preview
    
    @State private var ableToWithdraw: Bool = false
    
    var configs: Configs {
        if preview {
            return ConfigStore().configs
        } else {
            return fetchedConfigs.first ?? Configs(context: moc)
        }
    }
    
    var body: some View {
        Section(header: Text("Operation related settings")) {
            SettingsViewOperationWithdrawModeView(ableToWithdraw: $ableToWithdraw)
            SettingsViewOperationSetMinimalUnitView(minimalUnit: configs.minimalUnit)
            SettingsViewOperationsSetEndDateView(endDate: configs.endDate ?? Date())
        }
        .onAppear {
            ableToWithdraw = configs.ableToWithdraw
        }
        .onChange(of: ableToWithdraw) { value in
            configs.ableToWithdraw = value
            try? moc.save()
        }
    }
}

struct SettingsViewOperationSettings_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            SettingsViewOperationView()
        }
        .environment(\.isPreview, true)
    }
}
