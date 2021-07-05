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
    
    private let textInset: UIEdgeInsets
    static let defaultInsets = UIEdgeInsets(top: .spacing(.regular), left: .spacing(.regular), bottom: .spacing(.regular), right: .spacing(.regular))
    
    init(textInset: UIEdgeInsets) {
        self.textInset = textInset
        super.init(frame: .zero)
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        youngstDelegate?.deleteBackward()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: textInset)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: textInset)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: textInset)
    }
}
