//
//  ErrorWrapper.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 27/01/2022.
//

import Foundation

enum CustomErrorType: Int {
    case configSavingFailed = 1
    case configLoadingFailed = 2
}

struct ErrorWrapper: Identifiable {
    let id: UUID
    let error: Error
    let customErrorType: CustomErrorType
    let guidance: String
    
    init(id: UUID = UUID(), error: Error, customErrorType: CustomErrorType, guidance: String) {
        self.id = id
        self.error = error
        self.customErrorType = customErrorType
        self.guidance = guidance
    }
}
