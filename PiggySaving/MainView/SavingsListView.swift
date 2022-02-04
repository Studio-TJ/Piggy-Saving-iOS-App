//
//  SavingsListView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 28/01/2022.
//

import SwiftUI

struct Window: Shape {
    let size: CGSize
    func path(in rect: CGRect) -> Path {
        var path = Rectangle().path(in: rect)
        
        let origin = CGPoint(x: rect.midX - size.width / 2, y: rect.midY - size.height / 2)
        path.addRect(CGRect(origin: origin, size: size))
        return path
    }
}

func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}

struct SavingsListView: View {
    @ObservedObject var configs: ConfigStore
    @StateObject var allSaving: SavingDataStore = SavingDataStore()
    @State var sumSaving: Double = 0.0
    @State var listItemHasChange: Bool = false
    @State private var errorWrapper: ErrorWrapper?
    let displayOptions = ["Saving", "Cost"]
    @State var displayOption = "Saving"
    
    private func getAllSavingFromServer(sortDesc: Bool) {
        Task {
            do {
                self.allSaving.savings = try await ServerApi.getAllSaving(externalURL: configs.configs.externalURL!)
                self.allSaving.savings = self.allSaving.savings.sorted {
                    if sortDesc {
                        return $0.dateFormatted > $1.dateFormatted
                    } else {
                        return $0.dateFormatted < $1.dateFormatted
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func getSum() {
        Task {
            do {
                self.sumSaving = try await ServerApi.getSum(externalURL: self.configs.configs.externalURL!).sum
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 21).stroke(Color.accentColor, lineWidth: 1)
                    .frame(width: screenSize.width * 0.92, height: screenSize.height * 0.26)
                VStack {
                    HStack {
                        Text("Currently saved: " + String(self.sumSaving))
                            .font(Font.custom("SFProDisplay-Bold", size: 30))
                        Spacer()
                    }
                    HStack {
                        if let todaySaving = self.allSaving.savings.first {
                            Text("Today to save: " + String(todaySaving.amount))
                            Spacer()
                        }
                    }
                }
                .frame(width: screenSize.width * 0.92 - 10, height: screenSize.height * 0.26, alignment: .leading)
            }
            .frame(width: screenSize.width, height: screenSize.height * 0.32)
            .background(Color("MainPink"))
            if configs.configs.ableToWithdraw {
                Picker("", selection: $displayOption) {
                    ForEach(displayOptions, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
            }
            List {
                ForEach(allSaving.savings) { saving in
                    SavingListItemView(externalURL: $configs.configs.externalURL ?? "", itemUpdated: $listItemHasChange, saving: saving)
                }
                .listRowBackground(Color.clear)
            }
            .background(Color.clear)
            .zIndex(-1)
            .onChange(of: self.listItemHasChange) { value in
                // TODO: In the future implement a better event
                if value == true {
                    self.getAllSavingFromServer(sortDesc: true)
                    self.getSum()
                    self.listItemHasChange = false
                }
            }
            .onChange(of: self.allSaving.savings) { value in
                self.allSaving.updateFromSelfSavingArray()
            }
            .onChange(of: self.displayOption) { value in
                print(value)
            }
            .onAppear {
                UIView.appearance().backgroundColor = .clear
                self.getAllSavingFromServer(sortDesc: true)
                self.getSum()
            }
            .refreshable {
                self.getAllSavingFromServer(sortDesc: true)
                self.getSum()
            }
            .mask(LinearGradient(gradient: Gradient(colors: [Color("FrontColor"), Color("FrontColor"), Color("FrontColor"), Color("FrontColor").opacity(0)]), startPoint: .top, endPoint:. bottom))
        }
        .navigationBarHidden(true)
    }
}

struct SavingsListView_Previews: PreviewProvider {
    static var previews: some View {
        SavingsListView(configs: ConfigStore(), allSaving: SavingDataStore(savings: Saving.sampleData))
    }
}
