//
//  Label + Extension.swift
//  CompanyN
//
//  Created by 111 on 9/21/21.
//  Copyright © 2021 111. All rights reserved.
//

import Foundation

import UIKit

extension UILabel {
    
    convenience init(text: String) {
        self.init()
        
        self.text = text
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    convenience init(text: String, textColor: UIColor) {
        self.init()
        
        self.text = text
        self.textColor = textColor
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
