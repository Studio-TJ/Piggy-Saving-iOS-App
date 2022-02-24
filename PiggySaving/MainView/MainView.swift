//
//  MainView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 27/01/2022.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var configs: ConfigStore
    @StateObject var savingDataStore: SavingDataStore = SavingDataStore()
    @StateObject var states: States = States()
    @State var savingMonthShowList: [String: Bool] = [:]
    @State var costMonthShowList: [String: Bool] = [:]
    @StateObject var popupHandler = PopupHandler()
    
    var body: some View {
        ZStack {
            TabView(selection: $states.mainViewSelection) {
                SavingsListView(savingDataStore: savingDataStore, savingMonthShowList: $savingMonthShowList, costMonthShowList: $costMonthShowList)
                    .tag(MainTabItem.SAVINTS_LIST)
                    .environment(\.managedObjectContext, savingDataStore.container.viewContext)
                    .environmentObject(popupHandler)
                    .environmentObject(states)
                    .tabItem {
                        Image(systemName: "list.dash")
                        Text("Savings List")
                    }
                
                SettingsView()
                    .tag(MainTabItem.SETTINGS)
                    .environment(\.managedObjectContext, configs.container.viewContext)
                    .environmentObject(savingDataStore)
                    .environmentObject(popupHandler)
                    .environmentObject(states)
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
            }
        }
    }
}

enum MainTabItem: Int, Codable {
    case SAVINTS_LIST
    case SETTINGS
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(ConfigStore())
    }
}
