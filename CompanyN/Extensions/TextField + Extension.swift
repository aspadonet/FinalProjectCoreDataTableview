//
//  TextField + Extension.swift
//  CompanyN
//
//  Created by Alexander Avdacev on 9/21/21.
//  Copyright © 2021 111. All rights reserved.
//

import UIKit

extension UITextField {
    convenience init(placeholder: String?, text: String?) {
        self.init()
        self.text = text
        self.placeholder = placeholder
        self.borderStyle = .none
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var bottomView = UIView()
        bottomView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        bottomView.backgroundColor = .textFieldLight()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
    }
}
