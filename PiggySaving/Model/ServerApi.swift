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
            completion(.failure(ServerApiError.init(errorType: ServerApiError.ErrorType.invalidURL, errorURL: externalURL)))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                if let data = data {
                    let sum = try JSONDecoder().decode(Sum.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(sum))
                    }
                } else {
                    completion(.failure(ServerApiError(errorType: ServerApiError.ErrorType.serverDataNotRetrieved, errorURL: externalURL)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
    
    static func getAllSaving(externalURL: String) async throws -> [Saving] {
        try await withCheckedThrowingContinuation { continuation in
            getAllSaving(externalURL: externalURL) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let savings):
                    continuation.resume(returning: savings)
                }
            }
        }
    }
    
    private static func getAllSaving(externalURL: String, completion: @escaping (Result<[Saving], Error>) -> Void) {
        let json: [String: Bool] = [
            "desc": true,
            "withdraw": false
        ]
        
        guard let url = URL(string: externalURL + "/all") else {
            completion(.failure(ServerApiError.init(errorType: ServerApiError.ErrorType.invalidURL, errorURL: externalURL)))
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
                completion(.failure(error))
                return
            }
            do {
                var savings: [Saving] = []
                if let data = data {
                    let allSavings = try JSONDecoder().decode([String: Saving].self, from: data)
                    for allSaving in allSavings {
                        savings.append(allSaving.value)
                    }
                    DispatchQueue.main.async {
                        completion(.success(savings))
                    }
                } else {
                    completion(.failure(ServerApiError(errorType: ServerApiError.ErrorType.serverDataNotRetrieved, errorURL: externalURL)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    static func getAllCost(externalURL: String) async throws -> [Saving] {
        try await withCheckedThrowingContinuation { continuation in
            getAllCost(externalURL: externalURL) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let savings):
                    continuation.resume(returning: savings)
                }
            }
        }
    }
    
    // TODO: modify backend with better handling, more universal
    private static func getAllCost(externalURL: String, completion: @escaping (Result<[Saving], Error>) -> Void) {
        let json: [String: Bool] = [
            "desc": true,
            "withdraw": true
        ]
        
        guard let url = URL(string: externalURL + "/all") else {
            completion(.failure(ServerApiError.init(errorType: ServerApiError.ErrorType.invalidURL, errorURL: externalURL)))
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
                completion(.failure(error))
                return
            }
            do {
                var costs: [Saving] = []
                if let data = data {
                    let allCosts = try JSONDecoder().decode([String: Saving].self, from: data)
                    for allCost in allCosts {
                        costs.append(allCost.value)
                    }
                    DispatchQueue.main.async {
                        completion(.success(costs))
                    }
                } else {
                    completion(.failure(ServerApiError(errorType: ServerApiError.ErrorType.serverDataNotRetrieved, errorURL: externalURL)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    @discardableResult
    static func save(externalURL: String, date: String, isSaved: Bool) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            save(externalURL: externalURL, date: date, isSaved: isSaved) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let retval):
                    continuation.resume(returning: retval)
                }
            }
        }
    }
    
    private static func save(externalURL: String, date: String, isSaved: Bool, completion: @escaping (Result<Bool, Error>) -> Void) {
        let json: [String: Any] = [
            "date": date,
            "saved": isSaved
        ]
        
        guard let url = URL(string: externalURL + "/save") else {
            completion(.failure(ServerApiError.init(errorType: ServerApiError.ErrorType.invalidURL, errorURL: externalURL)))
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
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }.resume()
    }
    
    @discardableResult
    static func withdraw(externalURL: String, date: String, amount: Double, description: String, delete: Bool) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            withdraw(externalURL: externalURL, date: date, amount: amount, description: description, delete: delete ) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let retval):
                    continuation.resume(returning: retval)
                }
            }
        }
    }
    
    private static func withdraw(externalURL: String, date: String, amount: Double, description: String, delete: Bool, completion: @escaping (Result<Bool, Error>) -> Void) {
        let json: [String: Any] = [
            "date": date,
            "amount": amount,
            "description": description,
            "delete": delete
        ]
        
        guard let url = URL(string: externalURL + "/withdraw") else {
            completion(.failure(ServerApiError.init(errorType: ServerApiError.ErrorType.invalidURL, errorURL: externalURL)))
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
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }.resume()
    }
}
