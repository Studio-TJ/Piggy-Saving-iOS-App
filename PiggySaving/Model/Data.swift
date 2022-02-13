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

// Saving struct
struct Saving: Codable, Identifiable, Equatable, Hashable {
    let id = UUID().uuidString
    var date: String
    var amount: Double
    var saved: Int
    var description: String?
    var type: String
    
    var isSaved: Bool {
        return saved == 1 ? true : false
    }
    
    enum CodingKeys: CodingKey {
        case date
        case amount
        case saved
        case description
        case type
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
    
    var dateMonthYear: String {
        let format = "yyyyMM"
        let dateFormat = DateFormatter.dateFormat(fromTemplate: format, options: 0, locale: Locale.current)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self.dateFormatted)
    }
    
    init() {
        self.date = "2000-01-01"
        self.amount = 1
        self.saved = 0
        self.type = "saving"
    }
    
    init(saved: Int) {
        self.date = "2000-01-01"
        self.amount = 1
        self.saved = saved
        self.type = "saving"
    }
    
    init(savingData: SavingData) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.date = dateFormatter.string(from: savingData.date!)
        self.amount = savingData.amount
        self.saved = savingData.saved ? 1 : 0
        self.description = savingData.comment
        self.type = savingData.type ?? "saving"
    }
    
    init(date: String, amount: Double, saved: Int) {
        self.date = date
        self.amount = amount
        self.saved = saved
        self.type = "saving"
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
    
    convenience init(context: NSManagedObjectContext, cost: Saving) {
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
    @Published var costs: [Saving]
    let container = NSPersistentContainer(name: "PiggySavingData")
    
    var savingsByYearMonth: [[[Saving]]] {
        if savings.count == 0 {
            return []
        }
        var groupedByYear: [[Saving]] = []
        var groupedByYearMonth: [[[Saving]]] = []
        var lastYear = savings[0].dateLocalizedYear
        var yearArray: [Saving] = []
        
        // Group year, source should already be sorted
        for saving in savings {
            if saving.dateLocalizedYear != lastYear {
                groupedByYear.append(yearArray)
                yearArray = []
                lastYear = saving.dateLocalizedYear
            }
            yearArray.append(saving)
        }
        groupedByYear.append(yearArray)
        
        // Group by month
        var yearCount = 0
        var monthDayArray: [[Saving]] = []
        var dayArray: [Saving] = []
        for savingByYear in groupedByYear {
            var lastMonth = groupedByYear[yearCount][0].dateLocalizedMonth
            for saving in savingByYear {
                if saving.dateLocalizedMonth != lastMonth {
                    monthDayArray.append(dayArray)
                    dayArray = []
                    lastMonth = saving.dateLocalizedMonth
                }
                dayArray.append(saving)
            }
            monthDayArray.append(dayArray)
            groupedByYearMonth.insert(monthDayArray, at: yearCount)
            yearCount += 1
            monthDayArray = []
            dayArray = []
        }
        
        return groupedByYearMonth
    }
    
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
                let newCost = Saving(savingData: cost)
                self.costs.append(newCost)
            }
        }
    }
    
    convenience init(savings: [Saving], cost: [Saving]) {
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
