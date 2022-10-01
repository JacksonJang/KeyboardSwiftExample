//
//  RoundTextView.swift
//  KeyboardSwiftExample
//
//  Created by 장효원 on 2022/10/01.
//

import UIKit

class RoundTextView: UITextView {
    init() {
        super.init(frame: .zero, textContainer: .none)
        
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
