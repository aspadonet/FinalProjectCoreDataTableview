//
//  EmployeeHeaderView.swift
//  CompanyN
//
//  Created by Alexander Avdacev on 9.09.21.
//  Copyright © 2021 111. All rights reserved.
//

import UIKit

class EmployeeHeaderView: UITableViewHeaderFooterView {
    
    let headerLabel: UILabel = {
        let label   = UILabel()
        label.text  = "HeaderName"
        label.font  = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        headerLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.contentView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraint(){
        
        addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            headerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
}
