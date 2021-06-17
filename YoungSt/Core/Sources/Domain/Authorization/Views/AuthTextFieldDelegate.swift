//
//  File.swift
//  
//
//  Created by Роман Тищенко on 17.06.2021.
//

import Foundation
import Utilities

struct AuthTextFieldDelegate: TextFieldViewDelegate {
    let editingHandler: (Bool) -> ()
    
    func onEditingChanged(isEditing: Bool) {
        editingHandler(isEditing)
    }
}
