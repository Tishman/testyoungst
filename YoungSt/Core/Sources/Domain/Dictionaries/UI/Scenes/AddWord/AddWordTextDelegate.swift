//
//  File.swift
//  
//
//  Created by Nikita Patskov on 01.06.2021.
//

import Foundation
import Utilities

struct AddWordTextDelegate: TextEditingDelegate {
    
    let commitHandler: () -> Void
    
    func onCommit() {
        commitHandler()
    }
    
}
