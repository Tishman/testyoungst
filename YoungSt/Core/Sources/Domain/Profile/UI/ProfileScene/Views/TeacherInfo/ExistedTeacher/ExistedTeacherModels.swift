//
//  File.swift
//  
//
//  Created by Nikita Patskov on 22.06.2021.
//

import Foundation

struct TeacherInfoExistsState: Equatable {
    let profile: ProfileInfo
    
    var isLoading = false
}

enum ExistedTeacherAction: Equatable {
    case removeTeacher
}
