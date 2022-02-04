//
//  Data.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 28/01/2022.
//

import Foundation
import SwiftUI
import CoreData

struct LastSavingAmount: Codable {
    var amount: Double
    var saved: Int
    
    init() {
        self.amount = 0
        self.saved = 0
    }
}

struct Sum: Codable {
    var sum: Double
    
    init() {
        self.sum = 0
    }
}

 
struct Saving: Codable, Identifiable, Equatable {
    let id = UUID().uuidString
    var date: String
    var amount: Double
    var saved: Int
    
    var isSaved: Bool {
        return saved == 1 ? true : false
    }
    
    enum CodingKeys: CodingKey {
        case date
        case amount
        case saved
    }
    
    var dateFormatted: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self.date) ?? Date()
    }
    
    init() {
        self.date = "2000-01-01"
        self.amount = 1
        self.saved = 0
    }
    
    init(savingData: SavingData) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.date = dateFormatter.string(from: savingData.date!)
        self.amount = savingData.amount
        self.saved = savingData.saved ? 1 : 0
    }
}

extension Saving {
    init(date: String, amount: Double, saved: Int) {
        self.date = date
        self.amount = amount
        self.saved = saved
    }
    
    static let sampleData: [Saving] =
    [
        Saving(date: "2000-01-01", amount: 10.0, saved: 1),
        Saving(date: "2000-01-02", amount: 10.1, saved: 1),
        Saving(date: "2000-01-03", amount: 10.2, saved: 0)
    ]
}

extension SavingData {
    convenience init(context: NSManagedObjectContext, saving: Saving) {
        self.init(context: context)
        self.date = saving.dateFormatted
        self.amount = saving.amount
        self.saved = saving.isSaved
        self.type = "saving"
    }
}

class SavingDataStore: ObservableObject {
    @Published var savings: [Saving]
    let container = NSPersistentContainer(name: "PiggySavingData")
    
    init() {
        self.savings = []
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core data failed to load: \(error.localizedDescription)")
            }
        }
        
        let context = self.container.viewContext
        let fetchRequest = SavingData.fetchRequest()
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
 
        // TODO: think about error handling later.
        let savings = try? context.fetch(fetchRequest)
        
        if let savings = savings {
            savings.forEach { saving in
                let newSaving = Saving(savingData: saving)
                self.savings.append(newSaving)
            }
        }
    }
    
    convenience init(savings: [Saving]) {
        self.init()
        self.savings = savings
    }
    
    public func updateFromSelfSavingArray() -> Void {
        let context = self.container.viewContext
        let fetchRequest = SavingData.fetchRequest()
        let savings = try? context.fetch(fetchRequest)
        
        if let savings = savings {
            savings.forEach { saving in
                context.delete(saving)
            }
        }
        
        self.savings.forEach { saving in
            _ = SavingData(context: context, saving: saving)
        }
        try? context.save()
    }
    
    public func resetData() {
        let context = self.container.viewContext
        let fetchRequest = SavingData.fetchRequest()
        let savings = try? context.fetch(fetchRequest)
        
        if let savings = savings {
            savings.forEach { saving in
                context.delete(saving)
            }
        }
    }
}
