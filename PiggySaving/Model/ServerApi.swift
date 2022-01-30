//
//  DataStore.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 28/01/2022.
//

import Foundation

class ServerApi {
    
    static func getLast(externalURL: String) async throws -> LastAmount {
        try await withCheckedThrowingContinuation { continuation in
            getLast(externalURL: externalURL) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let last):
                    continuation.resume(returning: last)
                }
            }
        }
    }
        
    private static func getLast(externalURL: String, completion: @escaping (Result<LastAmount, Error>) -> Void) {
        guard let url = URL(string: externalURL + "/last") else {
            print("Invalid url..")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                let lastAmount = try JSONDecoder().decode(LastAmount.self, from: data!)
                DispatchQueue.main.async {
                    completion(.success(lastAmount))
                }
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
    
    static func getSum(externalURL: String) async throws -> Sum {
        try await withCheckedThrowingContinuation { continuation in
            getSum(externalURL: externalURL) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let sum):
                    continuation.resume(returning: sum)
                }
            }
        }
    }
    
    private static func getSum(externalURL: String, completion: @escaping (Result<Sum, Error>) -> Void) {
        guard let url = URL(string: externalURL + "/sum") else {
            print("Invalid url..")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                let sum = try JSONDecoder().decode(Sum.self, from: data!)
                DispatchQueue.main.async {
                    completion(.success(sum))
                }
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
    
    static func getAllSaving(externalURL: String, completion: @escaping (Result<[AllSaving], Error>) -> Void) {
        let json: [String: Bool] = [
            "desc": true,
            "withdraw": false
        ]
        
        struct RequestData: Encodable {
            let desc: Bool = true
            let withdraw: Bool = false
        }

        guard let url = URL(string: externalURL + "/all") else {
            print("Invalid url..")
            return
        }
        
        var request = URLRequest(url: url)
        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: json)
            request.httpBody = try JSONEncoder().encode(RequestData())
        } catch {
            print(error.localizedDescription)
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let dataString = String(data: data, encoding: .utf8) {
                    print(dataString)
                }
            }
            
        }.resume()
    }
}
