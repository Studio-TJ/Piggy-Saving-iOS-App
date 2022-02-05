//
//  ErrorView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 30/01/2022.
//

import SwiftUI

struct ErrorView: View {
    let errorWrapper: [ErrorWrapper]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Error(s) have occurred!")
                    .font(.title)
                    .padding(.bottom)
                ForEach(errorWrapper) { errorWrapper in
                    Text(errorWrapper.error.localizedDescription)
                        .font(.body)
                    Text(errorWrapper.guidance)
                        .font(.headline)
                        .padding(.top)
                    Spacer()
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    enum SampleError: Error {
        case errorRequired
    }
    
    static var wrapper: ErrorWrapper {
        ErrorWrapper(error: SampleError.errorRequired,
                     guidance: "You can safely ignore this error.")
    }
    
    static var previews: some View {
        ErrorView(errorWrapper: [wrapper])
    }
}
