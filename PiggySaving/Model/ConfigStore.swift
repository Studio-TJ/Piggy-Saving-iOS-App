//
//  ConfigStore.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 26/01/2022.
//

import Foundation

struct Configs: Codable {
    var isInitialized: Bool
    var usingExternalURL: Bool
    var externalURL: String
    var ableToWithdraw: Bool
    
    init() {
        self.isInitialized = false
        self.usingExternalURL = false
        self.externalURL = ""
        self.ableToWithdraw = false
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.isInitialized = try values.decode(Bool.self, forKey: .isInitialized)
        self.usingExternalURL = try values.decode(Bool.self, forKey: .usingExternalURL)
        self.externalURL = try values.decode(String.self, forKey: .externalURL)
        self.ableToWithdraw = try values.decodeIfPresent(Bool.self, forKey: .ableToWithdraw) ?? false
    }
    
    mutating func setIsInitialized(isInitialized: Bool) {
        self.isInitialized = isInitialized
    }
    
    mutating func setUsingExternalURL(usingExternalURL: Bool) {
        self.usingExternalURL = usingExternalURL
    }
    
    mutating func setExternalURL(externalURL: String) {
        self.externalURL = externalURL
    }
}

class ConfigStore: ObservableObject {
    @Published var configs = Configs()
    
    public func resetConfig() {
        self.configs = Configs()
    }
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent("configsore.data")
    }
    
    static func load() async throws -> Configs {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let configs):
                    continuation.resume(returning: configs)
                }
            }
        }
    }
    
    private static func load(completion: @escaping (Result<Configs, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success(Configs()))
                    }
                    return
                }
                let configs = try JSONDecoder().decode(Configs.self, from: file.availableData) 
                DispatchQueue.main.async {
                    completion(.success(configs))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    @discardableResult
    static func save(configs: Configs) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            save(configs: configs) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let success):
                    continuation.resume(returning: success)
                }
            }
        }
    }
    
    private static func save(configs: Configs, completion: @escaping (Result<Bool, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(configs)
                let outFile = try fileURL()
                try data.write(to: outFile)
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
