//
//  ConfigStore.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 26/01/2022.
//

import Foundation
import CoreData

struct ConfigServer: Codable {
    var minimalUnit: Double
    var endDate: String
    var numberOfDays: Int
    
    var endDateFormatted: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self.endDate) ?? Date()
    }
}

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
            self.configs.endDate = Date()
            self.configs.minimalUnit = 0.0
            self.configs.numberOfDays = 0
            try? context.save()
        }
    }
    
    convenience init(placeholder: Bool) {
        self.init()
        self.configs.minimalUnit = 0.2
        self.configs.endDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())!
        self.configs.numberOfDays = 30
    }
    
    public func finishInitialConfiguration() {
        if let context = configs.managedObjectContext {
            try? context.save()
        }
        self.configs = configs
    }
    
    public func updateLocalConfigFromServer() async throws {
        do {
            let config = try await ServerApi.retrieveConfig(externalURL: self.configs.externalURL ?? "")
            if let config = config {
                self.configs.minimalUnit = config.minimalUnit
                self.configs.numberOfDays = Int32(config.numberOfDays)
                self.configs.endDate = config.endDateFormatted
                try? self.container.viewContext.save()
            }
        } catch {
            throw error
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
