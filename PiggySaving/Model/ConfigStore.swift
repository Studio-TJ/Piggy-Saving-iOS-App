//
//  ConfigStore.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 26/01/2022.
//

import Foundation
import CoreData

class ConfigStore: ObservableObject {
    @Published var configs: Configs
    let container = NSPersistentContainer(name: "PiggySavingConfig")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core data failed to load: \(error.localizedDescription)")
            }
        }
        
        let context = self.container.viewContext
        let fetchRequest = Configs.fetchRequest()
        fetchRequest.fetchLimit = 1
        // TODO: think about error handling later.
        let configs = try? context.fetch(fetchRequest).first
        if let configs = configs {
            self.configs = configs
        } else {
            self.configs = Configs(context: context)
            self.configs.isInitialized = false
            self.configs.usingExternalURL = false
            self.configs.externalURL = ""
            self.configs.ableToWithdraw = false
            try? context.save()
        }
    }
    
    public func updateConfig() {
        if let context = configs.managedObjectContext {
            try? context.save()
        }
    }
    
    public func resetConfig() {
        self.configs = Configs()
    }
}
