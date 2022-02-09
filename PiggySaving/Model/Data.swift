//
//  Data.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 28/01/2022.
//

import Foundation
import SwiftUI
import CoreData

struct Sum: Codable {
    var sum: Double
    
    init() {
        self.sum = 0
    }
}

// TODO: later saving and cost struct can be combined, requires backend change
// Saving struct
struct Saving: Codable, Identifiable, Equatable, Hashable {
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
    
    var dateLocalizedMonthDay: String {
        let format = "MMMM d"
        let dateFormat = DateFormatter.dateFormat(fromTemplate: format, options: 0, locale: Locale.current)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self.dateFormatted)
    }
    
    var dateLocalizedMonth: String {
        let format = "MMMM"
        let dateFormat = DateFormatter.dateFormat(fromTemplate: format, options: 0, locale: Locale.current)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self.dateFormatted)
    }
    
    var dateLocalizedYear: String {
        let format = "yyyy"
        let dateFormat = DateFormatter.dateFormat(fromTemplate: format, options: 0, locale: Locale.current)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self.dateFormatted)
    }
    
    init() {
        self.date = "2000-01-01"
        self.amount = 1
        self.saved = 0
    }
    
    init(saved: Int) {
        self.date = "2000-01-01"
        self.amount = 1
        self.saved = saved
    }
    
    init(savingData: SavingData) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.date = dateFormatter.string(from: savingData.date!)
        self.amount = savingData.amount
        self.saved = savingData.saved ? 1 : 0
    }
    
    init(date: String, amount: Double, saved: Int) {
        self.date = date
        self.amount = amount
        self.saved = saved
    }
    
    static let sampleData1: [Saving] =
    [
        Saving(date: "2000-01-01", amount: 10.0, saved: 1),
        Saving(date: "2000-01-02", amount: 10.1, saved: 1),
        Saving(date: "2000-01-03", amount: 10.2, saved: 0)
    ]
    
    static let sampleData2: [Saving] =
    [
        Saving(date: "2000-02-01", amount: 10.0, saved: 1),
        Saving(date: "2000-02-02", amount: 10.1, saved: 1),
        Saving(date: "2000-02-03", amount: 10.2, saved: 0)
    ]
    
    static let sampleData3: [Saving] =
    [
        Saving(date: "2001-02-01", amount: 10.0, saved: 1),
        Saving(date: "2001-02-02", amount: 10.1, saved: 1),
        Saving(date: "2001-02-03", amount: 10.2, saved: 0)
    ]
}

// Cost struct
struct Cost: Codable, Identifiable, Equatable {
    let id = UUID().uuidString
    var date: String
    var amount: Double
    var description: String
    
    enum CodingKeys: CodingKey {
        case date
        case amount
        case description
    }
    
    var dateFormatted: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self.date) ?? Date()
    }
    
    init() {
        self.date = "2020-01-01"
        self.amount = 100
        self.description = "Test cost description"
    }
    
    init(costData: SavingData) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.date = dateFormatter.string(from: costData.date!)
        self.amount = costData.amount
        self.description = costData.comment ?? ""
    }
    
    init(date: String, amount: Double, description: String) {
        self.date = date
        self.amount = amount
        self.description = description
    }
    
    static let sampleData =
    [
        Cost(date: "2020-01-01", amount: 100, description: "Withdraw 100"),
        Cost(date: "2022-02-01", amount: 200, description: "Travel"),
        Cost(date: "2022-01-31", amount: 150, description: "Buy things")
    ]
}

// Extension of saving data
extension SavingData {
    convenience init(context: NSManagedObjectContext, saving: Saving) {
        self.init(context: context)
        self.date = saving.dateFormatted
        self.amount = saving.amount
        self.saved = saving.isSaved
        self.type = "saving"
        self.comment = "Saving"
    }
    
    convenience init(context: NSManagedObjectContext, cost: Cost) {
        self.init(context: context)
        self.date = cost.dateFormatted
        self.amount = cost.amount
        self.saved = true
        self.type = "cost"
        self.comment = cost.description
    }
}

class SavingDataStore: ObservableObject {
    @Published var savings: [Saving]
    @Published var costs: [Cost]
    let container = NSPersistentContainer(name: "PiggySavingData")
    
    init() {
        self.savings = []
        self.costs = []
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core data failed to load: \(error.localizedDescription)")
            }
        }
        
        // Get savings into memory
        let context = self.container.viewContext
        let savings = fetchSavings(context: context)
        if let savings = savings {
            savings.forEach { saving in
                let newSaving = Saving(savingData: saving)
                self.savings.append(newSaving)
            }
        }
        
        // Get cost into memory
        let costs = fetchCosts(context: context)
        if let costs = costs {
            costs.forEach { cost in
                let newCost = Cost(costData: cost)
                self.costs.append(newCost)
            }
        }
    }
    
    convenience init(savings: [Saving], cost: [Cost]) {
        self.init()
        self.savings = savings
        self.costs = cost
    }
    
    var totalSaving: Double {
        var total: Double = 0
        savings.forEach { saving in
            total += saving.amount
        }
        
        return total
    }
    
    var totalCost: Double {
        var total: Double = 0
        costs.forEach { cost in
            total += cost.amount
        }
        
        return total
    }
    
    public func updateFromSelfSavingArray() -> Void {
        let context = self.container.viewContext
        let savings = fetchSavings(context: context)
        
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
    
    public func updateFromSelfCostArray() -> Void {
        let context = self.container.viewContext
        let costs = fetchCosts(context: context)
        
        if let costs = costs {
            costs.forEach { cost in
                context.delete(cost)
            }
        }
        
        self.costs.forEach { cost in
            _ = SavingData(context: context, cost: cost)
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
    
    private func fetchSavings(context: NSManagedObjectContext) -> [SavingData]? {
        let fetchRequest = SavingData.fetchRequest()
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
 
        fetchRequest.predicate = NSPredicate(format: "type == %@", "saving")
        return try? context.fetch(fetchRequest)
    }
    
    private func fetchCosts(context: NSManagedObjectContext) -> [SavingData]? {
        let fetchRequest = SavingData.fetchRequest()
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
 
        fetchRequest.predicate = NSPredicate(format: "type == %@", "cost")
        return try? context.fetch(fetchRequest)
    }
}
