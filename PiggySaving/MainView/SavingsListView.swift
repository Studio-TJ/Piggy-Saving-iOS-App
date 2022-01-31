//
//  SavingsListView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 28/01/2022.
//

import SwiftUI

struct SavingsListView: View {
    @ObservedObject var configs: ConfigStore = ConfigStore()
    @State private var allSaving: [Saving] = []
    
    private func getAllSavingFromServer(sortDesc: Bool) {
        Task {
            do {
                allSaving = try await ServerApi.getAllSaving(externalURL: configs.configs.externalURL)
                allSaving = allSaving.sorted {
                    if sortDesc {
                        return $0.dateFormatted > $1.dateFormatted
                    } else {
                        return $0.dateFormatted < $1.dateFormatted
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(self.allSaving) { saving in
                ListItemView(saving: saving)
            }
        }
        .onAppear {
            self.getAllSavingFromServer(sortDesc: true)
        }
        .refreshable {
            self.getAllSavingFromServer(sortDesc: true)
        }
    }
}

struct SavingsListView_Previews: PreviewProvider {
    static var previews: some View {
        SavingsListView()
    }
}
