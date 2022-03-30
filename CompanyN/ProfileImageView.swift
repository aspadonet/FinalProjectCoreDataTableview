//
//  ProfileImageView.swift
//  CompanyN
//
//  Created by 111 on 9/12/21.
//  Copyright © 2021 111. All rights reserved.
//

import UIKit

class ProfileImageView: UIImageView {
    
    public override init(image: UIImage?){
        super.init(image: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 64, height: 64)
    }
    
}
