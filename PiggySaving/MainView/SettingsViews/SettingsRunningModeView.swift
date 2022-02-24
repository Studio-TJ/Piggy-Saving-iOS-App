//
//  SettingsRunningModeView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 12/02/2022.
//

import SwiftUI

enum RunningMode: String, CaseIterable {
    case LOCAL
    case SELF_HOSTED
    
    var rawValue: String {
        switch self {
        case .LOCAL: return "Local"
        case .SELF_HOSTED: return "Self-Hosted"
        }
    }
}

struct SettingsRunningModeView: View {
    @FetchRequest(entity: Configs.entity(), sortDescriptors: []) var fetchedConfigs: FetchedResults<Configs>
    @Environment(\.managedObjectContext) var moc
    @Environment(\.isPreview) var preview
    
    @EnvironmentObject var popupHandler: PopupHandler
    @EnvironmentObject var configStore: ConfigStore
    @EnvironmentObject var savingDataStore: SavingDataStore

    @State private var showRunningModeHelper = false
    @State private var modeSelection: RunningMode = .LOCAL
    
    var configs: Configs {
        if preview {
            return ConfigStore().configs
        } else {
            return fetchedConfigs.first ?? Configs(context: moc)
        }
    }
    
    var configMode: RunningMode {
        if configs.usingExternalURL {
            return .SELF_HOSTED
        } else {
            return .LOCAL
        }
    }
    
    var body: some View {
        Section(header: Text("Running Mode")) {
            HStack {
                Text("Running Mode")
                Button {
                    showRunningModeHelper = true
                } label: {
                    Image(systemName: "questionmark.circle.fill")
                }
                Spacer()
                Picker("", selection: $modeSelection) {
                    ForEach(RunningMode.allCases, id: \.self) { mode in
                        Text(mode.rawValue)
                    }
                }
                .pickerStyle(.menu)
            }
            .alert("You can switch between local and self-host mode. Switching from self-host to local will have no effect on your existing data. However switching from local to self-host will make your data be overwritten by the data from your server.", isPresented: $showRunningModeHelper) {
                Button("OK", role: .cancel) {}
            }

            if configs.usingExternalURL {
                VStack(alignment: .leading) {
                    Text("Server address:")
                    Text(configs.externalURL ?? "")
                }
                .colorMultiply(.gray)
            }
        }
        .onChange(of: modeSelection) { value in
            if value != configMode {
                if value == .LOCAL {
                    popupHandler.view = AnyView(ModeChangeConfirmationView(
                            description: "You are about to switch from self-hosted mode to local mode. This operation will detach your data on this device from your self-hosting server and is irreversible. Later if you want to switch back to self-hosting mode, your data will be overwritten by the data on server.",
                            selection: $modeSelection)
                                                    .environmentObject(popupHandler)
                                                    .environmentObject(configStore)
                                                    .environmentObject(savingDataStore)
                                                    .environment(\.managedObjectContext, moc)
                    )
                    popupHandler.popuped = true
                    
                } else {
                    popupHandler.view = AnyView(ModeChangeConfirmationView(
                            description: "You are about to switch from local mode to self-hosted mode. This operation will overwrite your local data by the data on your self-hosting server and is irreversible.",
                            selection: $modeSelection)
                                                    .environmentObject(popupHandler)
                                                    .environmentObject(configStore)
                                                    .environment(\.managedObjectContext, moc)
                    )
                    popupHandler.popuped = true
                }
            }
        }
        .onAppear {
            modeSelection = configs.usingExternalURL ? RunningMode.SELF_HOSTED : RunningMode.LOCAL
        }
    }
}

struct SettingsRunningModeView_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            SettingsRunningModeView()
                .environment(\.isPreview, true)
        }
    }
}
