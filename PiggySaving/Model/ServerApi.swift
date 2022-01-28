//
//  DataStore.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 28/01/2022.
//

import Foundation

class ServerApi: ObservableObject {
    @Published var lastAmount = 0
        
    public func getLast(externalURL: String, completion: @escaping (Result<LastAmount, Error>) -> Void) {
        guard let url = URL(string: externalURL + "/last") else {
            print("Invalid url..")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            let lastAmount = try! JSONDecoder().decode(LastAmount.self, from: data!)
            print(lastAmount)
        }
        .resume()
    }
    
    public func getSum(externalURL: String, completion: @escaping (Result<Sum, Error>) -> Void) {
        guard let url = URL(string: externalURL + "/sum") else {
            print("Invalid url..")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            let sum = try! JSONDecoder().decode(Sum.self, from: data!)
            print(sum)
        }
        .resume()
    }
}
