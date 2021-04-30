//
//  File.swift
//  
//
//  Created by Nikita Patskov on 29.04.2021.
//

import Foundation

enum CommonError: Equatable, Error {
    case unknownError
    case parseError(String)
}
