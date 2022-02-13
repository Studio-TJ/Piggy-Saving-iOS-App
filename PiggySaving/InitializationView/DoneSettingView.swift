//
//  DoneSettingView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 06/02/2022.
//

import SwiftUI

struct DoneSettingView: View {
    @EnvironmentObject var configs: ConfigStore
    
    @Binding var selectedItem: InitializationTabItem
    
    var body: some View {
        VStack {
            Text("Start your first saving.")
                .padding(.top, SCREEN_SIZE.height * 0.55)
            Button(action: {
                configs.configs.isInitialized = true
                configs.finishInitialConfiguration()
            }) {
                Text("Done")
                    .frame(minWidth: 0, maxWidth: SCREEN_SIZE.width * 0.3, minHeight: 50)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("MainPink"))
                    }
            }
            .padding(.top, SCREEN_SIZE.height * 0.05)
        }
        
    }
}

struct DoneSettingView_Previews: PreviewProvider {
    static var previews: some View {
        DoneSettingView(selectedItem: .constant(InitializationTabItem.DONE_SETTING))
            .environmentObject(ConfigStore())
    }
}
