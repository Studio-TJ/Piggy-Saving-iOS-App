//
//  WarningConfirmationView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 04/02/2022.
//

import SwiftUI

struct WarningConfirmationView: View {
    let description: String
    let cancelAction: () -> Void
    let confirmAction: () -> Void
    var body: some View {
        NavigationView {
            VStack {
                Text("Warning! You are Performing Dangerous Operations!")
                    .font(.title)
                    .padding(.bottom)
                Text(description)
                    .font(.headline)
                Spacer()
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack{
                        Button("Confirm") {
                            confirmAction()
                        }
                        .foregroundColor(Color.red)
                        Spacer()
                        Button("Cancel") {
                            cancelAction()
                        }
                    }
                }
            }
        }
    }
}

struct WarningConfirmationView_Previews: PreviewProvider {
    
    static var previews: some View {
        WarningConfirmationView(description: "", cancelAction: {}, confirmAction: {})
    }
}
