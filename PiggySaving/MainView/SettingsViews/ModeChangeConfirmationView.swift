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
    
    @State private var text: String = ""
    @Binding var selection: RunningMode
    
    var configs: Configs {
        if preview {
            return ConfigStore().configs
        } else {
            return fetchedConfigs.first ?? Configs(context: moc)
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Text(description)
                    .padding(.top, 20)
                Spacer()
                if selection == .SELF_HOSTED {
                    Text("Enter your server url here:")
                    TextField("https://", text: $text)
                        .padding(.leading, SCREEN_SIZE.width * 0.05)
                        .padding(.trailing, SCREEN_SIZE.width * 0.05)
                        .disableAutocorrection(true)
                        .keyboardType(.URL)
                }
                Divider()
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
                .padding(.bottom, 10)
                .frame(height: geo.size.height * 0.15)
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
        .frame(width: SCREEN_SIZE.width * 0.9, height: SCREEN_SIZE.height * 0.4)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("BackgroundColor"))
                .frame(minWidth: SCREEN_SIZE.width * 0.9, minHeight: 250)
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
