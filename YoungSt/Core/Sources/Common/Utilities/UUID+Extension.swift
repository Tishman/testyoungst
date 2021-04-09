//
//  File.swift
//  
//
//  Created by Nikita Patskov on 03.04.2021.
//

import Foundation

public extension UUID {
    
    static func from(string: String) throws -> UUID {
        guard let id = UUID(uuidString: string) else {
            throw NSError(domain: "ParseErrorDomain", code: 0, userInfo: nil)
        }
        return id
    }
    
}
