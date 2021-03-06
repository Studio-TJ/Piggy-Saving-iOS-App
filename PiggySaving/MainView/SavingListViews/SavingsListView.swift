//
//  SavingsListView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 28/01/2022.
//

import SwiftUI

private struct PositionPreferenceKey: PreferenceKey {
  typealias Value = CGFloat

  static var defaultValue = CGFloat()

  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
      value = nextValue()
  }
}

struct SavingsListView: View {
    let displayOptions = ["Saving", "Cost"]
    
    @EnvironmentObject var configs: ConfigStore
    @ObservedObject var savingDataStore: SavingDataStore
    @EnvironmentObject var states: States
    @State private var errorWrapper: [ErrorWrapper] = []
    @State var displayOption = "Saving"
    @State var hasError = false
    @State var showWithDrawPicker = false
    @State private var offset = CGFloat.zero
    @State private var refreshed = false
    
    @Binding var savingMonthShowList: [String: Bool]
    @Binding var costMonthShowList: [String: Bool]
    
    @EnvironmentObject var popupHandler: PopupHandler
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Image(systemName: "arrow.clockwise.circle")
                    Text("Refresh")
                }
                .opacity(min(offset / (SCREEN_SIZE.height * 0.1), 1))
                .background(
                    Rectangle()
                        .fill(Color("MainPink"))
                        .edgesIgnoringSafeArea(.top)
                        .frame(width: SCREEN_SIZE.width, height: (offset >= 0) ? 150 + offset : 0)
                )
                Spacer()
            }
            ScrollView {
                ZStack {
                    LazyVStack {
                        SavingListHeaderView(currentBalance: savingDataStore.totalSavingActual, totalSavings: savingDataStore.totalSaving, totalExpenses: savingDataStore.totalCost)
                        if configs.configs.ableToWithdraw {
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
                                    Button("Record Withdraw") {
                                        popupHandler.view = AnyView(CostEditView()
                                                                        .environmentObject(popupHandler)
                                                                        .environmentObject(states))
                                        withAnimation(.linear(duration: 0.2)) {
                                            popupHandler.popuped = true
                                        }
                                    }
                                    .frame(width: 100, height: 44)
                                    .background(RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.green))
                                    .padding(.trailing, 25)
                                } else {
                                    Button("Record Withdraw") {
                                    }
                                    .frame(width: 100, height: 44)
                                    .foregroundColor(Color.clear)
                                    .background(RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.clear))
                                    .padding(.trailing, 25)
                                }
                            }
                            .padding(.top, 20)
                        }
                        Section {
                            if self.displayOption == "Saving" {
                                ForEach(savingDataStore.savingsByYearMonth, id: \.self) { savingsByYear in
                                    SavingListYearView(savings: savingsByYear, type: "Saving", monthShowList: $savingMonthShowList)
                                }
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(Color.clear)
                            } else {
                                ForEach(savingDataStore.costsByYearMonth, id: \.self) { costByYear in
                                    SavingListYearView(savings: costByYear, type: "Cost", monthShowList: $costMonthShowList)
                                }
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(Color.clear)
                            }
                        }
                        .onChange(of: self.states.savingDataChanged) { value in
                            if value == true {
                                if configs.configs.usingExternalURL == true {
                                    self.getAllSavingFromServer(sortDesc: true)
                                    self.getAllCostFromServer(sortDesc: true)
                                } else {
                                    self.savingDataStore.fetchSavingFromPersistent()
                                    self.savingDataStore.fetchCostFromPersistent()
                                }
                                self.states.savingDataChanged = false
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
                            }
                        }
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    GeometryReader { proxy in
                        let offset = proxy.frame(in: .named("scroll")).minY
                        Color.clear.preference(key: PositionPreferenceKey.self, value: offset)
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(PositionPreferenceKey.self) { value in
                let generator = UINotificationFeedbackGenerator()
                if value > 10 {
                    generator.prepare()
                }
                if value > 0 {
                    offset = value
                    if refreshed == false && value > SCREEN_SIZE.height * 0.15 {
                        generator.notificationOccurred(.success)
                        refreshed = true
                        if configs.configs.usingExternalURL {
                            self.getAllSavingFromServer(sortDesc: true)
                            self.getAllCostFromServer(sortDesc: true)
                        }
                    }
                } else  {
                    if value < -50 {
                        offset = -1
                    } else {
                        offset = 0
                    }
                    if refreshed == true {
                        refreshed = false
                    }
                }
            }
            .sheet(isPresented: $hasError, onDismiss: {
                self.errorWrapper.removeAll()
                self.hasError = false
            }) {
                ErrorView(errorWrapper: errorWrapper)
            }
            .blur(radius: popupHandler.popuped ? 5 : 0)
            .disabled(popupHandler.popuped)

            if popupHandler.popuped {
                popupHandler.view.transition(.opacity)
            }
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
}

struct SavingsListView_Previews: PreviewProvider {
    static var previews: some View {
        SavingsListView(savingDataStore: SavingDataStore(savings: Saving.sampleData1 + Saving.sampleData2 + Saving.sampleData3, cost: Saving.sampleData4 + Saving.sampleData5 + Saving.sampleData6), savingMonthShowList: .constant([:]), costMonthShowList: .constant([:]))
            .environmentObject(ConfigStore())
    }
}
