//
//  DataStorageView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 06/02/2022.
//

import SwiftUI

struct DataStorageView: View {
    var body: some View {
        VStack {
            Text("By default, your data will be stored locally on this device. In the future we will add iCloud storage and backup features. ")
            Spacer()
            Button {
            } label: {
                Text("If you are a power user and want to self-host your PiggySaving backend, click here for detail.")
                    .underline()
                    .foregroundColor(Color.gray)
            }

        }
    }
}

struct DataStorageView_Previews: PreviewProvider {
    static var previews: some View {
        DataStorageView()
    }
}
