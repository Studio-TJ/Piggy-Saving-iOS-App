//
//  ModeChangeConfirmationView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 19/02/2022.
//

import SwiftUI

struct ModeChangeConfirmationView: View {
    @FetchRequest(entity: Configs.entity(), sortDescriptors: []) var fetchedConfigs: FetchedResults<Configs>
    @Environment(\.managedObjectContext) var moc
    @Environment(\.isPreview) var preview
    
    @EnvironmentObject var popupHandler: PopupHandler
    
    let description: String
    
    @Binding var selection: RunningMode
    @State private var text: String = ""
    
    var configs: Configs {
        if preview {
            return ConfigStore().configs
        } else {
            return fetchedConfigs.first ?? Configs(context: moc)
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                Text(description)
                    .padding(.top, 20)
                if selection == .SELF_HOSTED {
                    Text("Enter your server url here:")
                        .padding(.top, 10)
                    TextField("https://", text: $text)
                        .padding(.leading, SCREEN_SIZE.width * 0.05)
                        .padding(.trailing, SCREEN_SIZE.width * 0.05)
                        .disableAutocorrection(true)
                        .keyboardType(.URL)
                }
            }
            VStack {
                Divider()
                    .padding(.bottom, 5)
                HStack {
                    Spacer()
                    Button {
                        if selection == .SELF_HOSTED {
                            configs.usingExternalURL = true
                            configs.externalURL = text.lowercased()
                        } else {
                            configs.usingExternalURL = false
                            configs.externalURL = nil
                        }
                        try? moc.save()
                        dismiss()
                    } label: {
                        Text("Confirm")
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Button("**Cancel**") {
                        selection = selection == .SELF_HOSTED ? .LOCAL : .SELF_HOSTED
                        dismiss()
                    }
                    Spacer()
                }
            }
            .padding(.bottom, 10)
            .frame(height: 50)
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
        .frame(width: SCREEN_SIZE.width * 0.9)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("BackgroundColor"))
                .frame(width: SCREEN_SIZE.width * 0.9)
                .shadow(color: Color("AccentColor").opacity(0.2), radius: 16)
        )
    }
    
    private func dismiss() {
        popupHandler.popuped = false
        popupHandler.view = AnyView(EmptyView())
    }
}

struct ModeChangeConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ModeChangeConfirmationView(description: "You are about to switch from local mode to self-hosted mode. Your local data will be overwritten by the data on your self-hosting server. This action is irreversible.", selection: .constant(.SELF_HOSTED))
            .environment(\.isPreview, true)
    }
}
