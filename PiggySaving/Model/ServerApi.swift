//
//  DataStore.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 28/01/2022.
//

import Foundation

class ServerApi {
    
    struct ServerApiError: Error, LocalizedError {
        
        enum ErrorType {
            case invalidURL
            case serverDataNotRetrieved
        }
        
        let errorType: ErrorType
        let errorURL: String?
        
        init(errorType: ErrorType, errorURL: String) {
            self.errorType = errorType
            self.errorURL = errorURL
        }
        
        var errorDescription: String? {
            switch self.errorType {
            case.invalidURL:
                return NSLocalizedString("Provided URL is invalid.", comment: "Invalid URL")
            case .serverDataNotRetrieved:
                return NSLocalizedString("Server data from URL: " + (self.errorURL ?? "") + " cannot be retrived.", comment: "Server data not retrived.")
            }
        }
    }
    
    static func getAllSaving(externalURL: String) async throws -> [Saving] {
        try await withCheckedThrowingContinuation { continuation in
            let json: [String: Bool] = [
                "desc": true,
                "withdraw": false
            ]
            
            guard let url = URL(string: externalURL + "/all") else {
                continuation.resume(throwing: ServerApiError(errorType: ServerApiError.ErrorType.invalidURL, errorURL: externalURL))
                return
            }
            
            var request = URLRequest(url: url)
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: json)
            } catch {
                print(error.localizedDescription)
            }
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                do {
                    var savings: [Saving] = []
                    if let data = data {
                        let allSavings = try JSONDecoder().decode([String: Saving].self, from: data)
                        for allSaving in allSavings {
                            savings.append(allSaving.value)
                        }
                        continuation.resume(returning: savings)
                    } else {
                        continuation.resume(throwing: ServerApiError(errorType: ServerApiError.ErrorType.serverDataNotRetrieved, errorURL: externalURL))
                        return
                    }
                } catch {
                    continuation.resume(throwing: error)
                    return
                }
            }.resume()
        }
    }
    
    static func getAllCost(externalURL: String) async throws -> [Saving] {
        try await withCheckedThrowingContinuation { continuation in
            let json: [String: Bool] = [
                "desc": true,
                "withdraw": true
            ]
            
            guard let url = URL(string: externalURL + "/all") else {
                continuation.resume(throwing: ServerApiError.init(errorType: ServerApiError.ErrorType.invalidURL, errorURL: externalURL))
                return
            }
            
            var request = URLRequest(url: url)
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: json)
            } catch {
                print(error.localizedDescription)
            }
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                do {
                    var costs: [Saving] = []
                    if let data = data {
                        let allCosts = try JSONDecoder().decode([String: Saving].self, from: data)
                        for allCost in allCosts {
                            costs.append(allCost.value)
                        }
                        continuation.resume(returning: costs)
                    } else {
                        continuation.resume(throwing: ServerApiError(errorType: ServerApiError.ErrorType.serverDataNotRetrieved, errorURL: externalURL))
                        return
                    }
                } catch {
                    continuation.resume(throwing: error)
                    return
                }
            }.resume()
        }
    }

    @discardableResult
    static func save(externalURL: String, date: String, isSaved: Bool) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            let json: [String: Any] = [
                "date": date,
                "saved": isSaved
            ]
            
            guard let url = URL(string: externalURL + "/save") else {
                continuation.resume(throwing: ServerApiError.init(errorType: ServerApiError.ErrorType.invalidURL, errorURL: externalURL))
                return
            }
            
            var request = URLRequest(url: url)
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: json)
            } catch {
                print(error.localizedDescription)
            }
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            // TODO: error handle with response and error
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: true)
                }
            }.resume()
        }
    }
    
    @discardableResult
    static func withdraw(externalURL: String, date: String, amount: Double, description: String, sequence: Int, delete: Bool) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            let json: [String: Any] = [
                "date": date,
                "amount": amount,
                "description": description,
                "delete": delete,
                "sequence": sequence
            ]
            
            guard let url = URL(string: externalURL + "/withdraw") else {
                continuation.resume(throwing: ServerApiError.init(errorType: ServerApiError.ErrorType.invalidURL, errorURL: externalURL))
                return
            }
            
            var request = URLRequest(url: url)
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: json)
            } catch {
                print(error.localizedDescription)
            }
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            // TODO: error handle with response and error
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: true)
                }
            }.resume()
        }
    }
    
    static func roll(externalURL: String, date: String) async throws -> Double? {
        try await withCheckedThrowingContinuation { continuation in
            let json: [String: Any] = [
                "date": date
            ]
            
            guard let url = URL(string: externalURL + "/roll") else {
                continuation.resume(throwing: ServerApiError.init(errorType: ServerApiError.ErrorType.invalidURL, errorURL: externalURL))
                return
            }
            
            var request = URLRequest(url: url)
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: json)
            } catch {
                print(error.localizedDescription)
            }
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            // TODO: error handle with response and error
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                do {
                    if let data = data {
                        let result = try JSONDecoder().decode([String: Double].self, from: data)
                        continuation.resume(returning: result["newNum"])
                    } else {
                        continuation.resume(throwing: ServerApiError(errorType: ServerApiError.ErrorType.serverDataNotRetrieved, errorURL: externalURL))
                        return
                    }
                } catch {
                    continuation.resume(throwing: error)
                    return
                }
            }.resume()
        }
    }
    
    static func retrieveConfig(externalURL: String) async throws -> ConfigServer? {
        try await withCheckedThrowingContinuation { continuation in
           
            guard let url = URL(string: externalURL + "/retrieveconfig") else {
                continuation.resume(throwing: ServerApiError.init(errorType: ServerApiError.ErrorType.invalidURL, errorURL: externalURL))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            // TODO: error handle with response and error
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                do {
                    if let data = data {
                        let result = try JSONDecoder().decode(ConfigServer.self, from: data)
                        continuation.resume(returning: result)
                    } else {
                        continuation.resume(throwing: ServerApiError(errorType: ServerApiError.ErrorType.serverDataNotRetrieved, errorURL: externalURL))
                        return
                    }
                } catch {
                    continuation.resume(throwing: error)
                    return
                }
            }.resume()
        }
    }
}
