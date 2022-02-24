//
//  ModePickerView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 23/02/2022.
//

import SwiftUI

struct ModePickerView: View {
    let selection: [String]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8.91)
        }
        .ignoresSafeArea(.all)
    }
}

struct ModePickerView_Previews: PreviewProvider {
    static var previews: some View {
        let selection = ["Saving", "Expenses"]
        ModePickerView(selection: selection)
            .previewLayout(.sizeThatFits)
    }
}
