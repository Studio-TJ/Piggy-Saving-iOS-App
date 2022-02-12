//
//  DataStorageView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 06/02/2022.
//

import SwiftUI

struct DataStorageView: View {
    @FetchRequest(entity: Configs.entity(), sortDescriptors: []) var fetchedConfigs: FetchedResults<Configs>
    @Environment(\.managedObjectContext) var moc
    var preview: Bool = false
    
    var configs: Configs {
        if preview {
            return ConfigStore().configs
        } else {
            return fetchedConfigs.first ?? Configs(context: moc)
        }
    }
    
    @State var serverURL = ""
    @State var showPowerUserGuide = false
    var body: some View {
        VStack {
            HStack {
                Text("Data storage")
                    .font(Fonts.TITLE_SEMIBOLD)
                Spacer()
            }
            .padding(20)
            Image(systemName: "internaldrive")
                .font(.system(size: 120))
            Text("By default, your data will be stored locally on this device. No other party will have access of your data. If you are a power user, you can also choose to self-host your backend server. ")
                .padding(20)
            Spacer()
            Button {
                showPowerUserGuide = true
            } label: {
                Text("Power user? Click here.")
                    .underline()
                    .foregroundColor(Color.gray)
            }
            .onAppear {
                print("data")
            }
            .padding(.bottom, SCREEN_SIZE.height * 0.1)
            .sheet(isPresented: $showPowerUserGuide) {
                NavigationView {
                    DataStoragePowerUserView(configs: configs)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    showPowerUserGuide = false
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Save") {
                                    showPowerUserGuide = false
                                    configs.usingExternalURL = true
                                    try? moc.save()
                                }
                            }
                        }
                }
            }
        }
        
    }
}

struct DataStorageView_Previews: PreviewProvider {
    static var previews: some View {
        DataStorageView(preview: true)
    }
}
