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
    @State var savingMonthShowList: [String: Bool] = [:]
    @State var costMonthShowList: [String: Bool] = [:]
    
    @State var showOverlay = true
    
    var body: some View {
        ZStack {
            TabView {
                SavingsListView(savingDataStore: savingDataStore, savingMonthShowList: $savingMonthShowList, costMonthShowList: $costMonthShowList)
                    .environment(\.managedObjectContext, savingDataStore.container.viewContext)
                    .tabItem {
                        Image(systemName: "list.dash")
                        Text("Savings List")
                    }
                
                SettingsView()
                    .environment(\.managedObjectContext, configs.container.viewContext)
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
            }
            .blur(radius: showOverlay ? 15 : 0)
            .disabled(showOverlay)
//            if showOverlay {
                SaveConfirmationView(toggle: $showOverlay)
//            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(ConfigStore())
    }
}
