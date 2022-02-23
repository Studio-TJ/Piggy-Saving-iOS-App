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
    @EnvironmentObject var configStore: ConfigStore
    
    let description: String
    
    @Binding var selection: RunningMode
    @State private var text: String = ""
    @State private var errorWrapper: [ErrorWrapper] = []
    @State private var hasError = false
    
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
                            try? moc.save()
                            dismiss()
                        } else {
                            self.updateAndSwitchToLocalConfig()
                        }
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
        .frame(width: min(SCREEN_SIZE.width * 0.9, 400))
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("BackgroundColor"))
                .frame(width: min(SCREEN_SIZE.width * 0.9, 400))
                .shadow(color: Color("AccentColor").opacity(0.2), radius: 16)
        )
        .onChange(of: self.errorWrapper.count) { value in
            self.hasError = value > 0 ? true : false
        }
        .sheet(isPresented: $hasError, onDismiss: {
            self.errorWrapper.removeAll()
            self.hasError = false
        }) {
            ErrorView(errorWrapper: errorWrapper)
        }
    }
    
    private func dismiss() {
        popupHandler.popuped = false
        popupHandler.view = AnyView(EmptyView())
    }
    
    private func updateAndSwitchToLocalConfig() {
        Task {
            do {
                let configRemote = try await ServerApi.retrieveConfig(externalURL: configs.externalURL ?? "")
                if let configRemote = configRemote {
                    configs.minimalUnit = configRemote.minimalUnit
                    configs.endDate = configRemote.endDateFormatted
                    configs.numberOfDays = Int32(configRemote.numberOfDays)
                }
                
                configs.usingExternalURL = false
                configs.externalURL = nil
                try? moc.save()
                dismiss()
            } catch {
                self.errorWrapper.append(ErrorWrapper(error: error, guidance: NSLocalizedString("Cannot retrieve config from server. Please check your network connection and try again later. If you are sure that your network connection is working properly, please contact the developer. You can safely dismiss this page for now.", comment: "Retrieve config from server error guidance.")))
            }
        }
    }
}

struct ModeChangeConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ModeChangeConfirmationView(description: "You are about to switch from local mode to self-hosted mode. Your local data will be overwritten by the data on your self-hosting server. This action is irreversible.", selection: .constant(.SELF_HOSTED))
            .environment(\.isPreview, true)
    }
}
