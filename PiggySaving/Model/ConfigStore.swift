//
//  ConfigStore.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 26/01/2022.
//

import Foundation

class ConfigStore: ObservableObject {
    @Published var isInitialized = false
    @Published var usingExternalURL = false
    @Published var externalURL: String = ""
}
