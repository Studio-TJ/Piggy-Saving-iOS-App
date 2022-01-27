//
//  LocalUsageView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 27/01/2022.
//

import SwiftUI

struct LocalUsageView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView {
            VStack {
                Text("This mode is not available yet.")
                    .font(.title)
                    .padding(.bottom)
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct LocalUsageView_Previews: PreviewProvider {
    static var previews: some View {
        LocalUsageView()
    }
}
