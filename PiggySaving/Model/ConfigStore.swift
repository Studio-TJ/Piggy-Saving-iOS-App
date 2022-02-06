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
            self.configs.currency = Currency.undefined.rawValue
            self.configs.amountRatio = 1
            self.configs.endDate = Date()
            self.configs.minimalUnit = 0.0
            try? context.save()
        }
    }
    
    convenience init(currency: Int32) {
        self.init()
        self.configs.currency = currency
        self.configs.endDate = Date()
    }
    
    public func updateConfig() {
        if let context = configs.managedObjectContext {
            try? context.save()
        }
    }
    
    public func resetConfig() {
        let context = self.container.viewContext
        let fetchRequest = Configs.fetchRequest()
        let configs = try? context.fetch(fetchRequest)
        if let configs = configs {
            configs.forEach { config in
                context.delete(config)
            }
        }
        self.configs = Configs(context: context)
        try? context.save()
    }
}
