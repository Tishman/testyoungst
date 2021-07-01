//
//  File.swift
//  
//
//  Created by Роман Тищенко on 01.07.2021.
//

import Foundation
import UIKit

protocol YoungstTextFieldDelegate {
    func deleteBackward()
}

final class YoungstTextField: UITextField {
    var youngstDelegate: YoungstTextFieldDelegate?
    
    override func deleteBackward() {
        super.deleteBackward()
        youngstDelegate?.deleteBackward()
    }
}
