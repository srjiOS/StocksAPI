//
//  ErrorResponse.swift
//
//
//  Created by Sumit Raj on 05/06/24.
//

import Foundation

public struct ErrorResponse: Codable {
    public let code: String
    public let description: String
    
    public init(code: String, description: String) {
        self.code = code
        self.description = description
    }
}
