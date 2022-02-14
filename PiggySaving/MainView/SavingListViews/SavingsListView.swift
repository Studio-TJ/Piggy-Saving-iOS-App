//
//  SavingsListView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 28/01/2022.
//

import SwiftUI

struct SavingsListView: View {
    let displayOptions = ["Saving", "Cost"]
    
    @EnvironmentObject var configs: ConfigStore
    @ObservedObject var savingDataStore: SavingDataStore
    
    @State var sumSaving: Double = 0.0
    @State var listItemHasChange: Bool = false
    @State private var errorWrapper: [ErrorWrapper] = []
    @State var displayOption = "Cost"
    @State var hasError = false
    @State var showWithDrawPicker = false
    
    @Binding var savingMonthShowList: [String: Bool]
    @Binding var costMonthShowList: [String: Bool]
    
    var body: some View {
        VStack(spacing: 0) {
            SavingListOverviewView(sumSaving: self.sumSaving, totalSaving: savingDataStore.totalSaving, totalCost: savingDataStore.totalCost)
            if true {
                HStack {
                    Picker("", selection: $displayOption) {
                        ForEach(displayOptions, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: 160)
                    Spacer(minLength: 50)
                    if displayOption == "Cost" {
                        Button("Record Saving") {
                            
                        }
                        .frame(width: 100, height: 44)
                        .background(RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.green))
                        .padding(.trailing, 25)
                    } else {
                        Button("Record Saving") {
                            
                        }
                        .frame(width: 100, height: 44)
                        .foregroundColor(Color.clear)
                        .background(RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.clear))
                        .padding(.trailing, 25)
                    }
                }
                .padding(.top, 20)
                .background(Color("ListBG"))
            }
            List {
                if self.displayOption == "Saving" {
                    ForEach(savingDataStore.savingsByYearMonth, id: \.self) { savingsByYear in
                        SavingListYearView(savings: savingsByYear, externalURL: configs.configs.externalURL ?? "", type: "Saving", monthShowList: $savingMonthShowList, itemUpdated: $listItemHasChange)
                        
                    }
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(savingDataStore.costsByYearMonth, id: \.self) { costByYear in
                        SavingListYearView(savings: costByYear, externalURL: configs.configs.externalURL ?? "", type: "Cost", monthShowList: $costMonthShowList, itemUpdated: $listItemHasChange)
                    }
                    .listRowBackground(Color.clear)
                    .swipeActions {
                        Button("Edit") {
                            print("edit")
                        }
                        .tint(.blue)
                    }
                }
            }
            .zIndex(-1)
            .onChange(of: self.listItemHasChange) { value in
                if value == true {
                    if configs.configs.usingExternalURL == true {
                        self.getAllSavingFromServer(sortDesc: true)
                        self.getSum()
                    } else {
                        self.savingDataStore.fetchSavingFromPersistent()
                    }
                    self.listItemHasChange = false
                }
            }
            .onChange(of: self.savingDataStore.savings) { value in
                self.savingDataStore.updateFromSelfSavingArray()
            }
            .onChange(of: self.savingDataStore.costs) { value in
                self.savingDataStore.updateFromSelfCostArray()
            }
            .onChange(of: self.errorWrapper.count) { value in
                self.hasError = value > 0 ? true : false
            }
            .onAppear {
                showWithDrawPicker = configs.configs.ableToWithdraw
                if configs.configs.usingExternalURL {
                    self.getAllSavingFromServer(sortDesc: true)
                    self.getAllCostFromServer(sortDesc: true)
                    self.getSum()
                }
            }
            .refreshable {
                if configs.configs.usingExternalURL {
                    self.getAllSavingFromServer(sortDesc: true)
                    self.getAllCostFromServer(sortDesc: true)
                    self.getSum()
                }
            }
        }
        .sheet(isPresented: $hasError, onDismiss: {
            self.errorWrapper.removeAll()
            self.hasError = false
        }) {
            ErrorView(errorWrapper: errorWrapper)
        }
    }
    
    private func getAllSavingFromServer(sortDesc: Bool) {
        Task {
            do {
                self.savingDataStore.savings = try await ServerApi.getAllSaving(externalURL: configs.configs.externalURL!)
                self.savingDataStore.savings = self.savingDataStore.savings.sorted {
                    if sortDesc {
                        return $0.dateFormatted > $1.dateFormatted
                    } else {
                        return $0.dateFormatted < $1.dateFormatted
                    }
                }
            } catch {
                self.errorWrapper.append(ErrorWrapper(error: error, guidance: NSLocalizedString("Cannot retrieve all savings from server. Please check your network connection and try again later. If you are sure that your network connection is working properly, please contact the developer. You can safely dismiss this page for now.", comment: "Get all saving from server error guidance.")))
            }
        }
    }
    
    private func getAllCostFromServer(sortDesc: Bool) {
        Task {
            do {
                self.savingDataStore.costs = try await ServerApi.getAllCost(externalURL: configs.configs.externalURL!)
                self.savingDataStore.costs = self.savingDataStore.costs.sorted {
                    if sortDesc {
                        return $0.dateFormatted > $1.dateFormatted
                    } else {
                        return $0.dateFormatted < $1.dateFormatted
                    }
                }
            } catch {
                self.errorWrapper.append(ErrorWrapper(error: error, guidance: "Cannot retrieve all costs from server. Please check your network connection and try again later. If you are sure that your network connection is working properly, please contact the developer. You can safely dismiss this page for now."))
            }
        }
    }
    
    private func getSum() {
        Task {
            do {
                self.sumSaving = try await ServerApi.getSum(externalURL: self.configs.configs.externalURL!).sum
            } catch {
                self.errorWrapper.append(ErrorWrapper(error: error, guidance: "Cannot retrieve sum from server. Please check your network connection and try again later. If you are sure that your network connection is working properly, please contact the developer. You can safely dismiss this page for now."))
            }
        }
    }
}

struct SavingsListView_Previews: PreviewProvider {
    static var previews: some View {
        SavingsListView(savingDataStore: SavingDataStore(savings: Saving.sampleData1 + Saving.sampleData2 + Saving.sampleData3, cost: Saving.sampleData1), savingMonthShowList: .constant([:]), costMonthShowList: .constant([:]))
            .environmentObject(ConfigStore())
    }
}
