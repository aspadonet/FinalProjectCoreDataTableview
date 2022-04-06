//
//  EmployeeInOfficeCell.swift
//  CompanyN
//
//  Created by Alexander Avdacev on 9/13/21.
//  Copyright © 2021 111. All rights reserved.
//

import UIKit

class EmployeeInOfficeCell: UITableViewCell {
    
    var employee: Employee? {
        didSet{
            guard let employee = employee else { return }
            let fullNameString = employee.firstName! + " " + employee.lastName!
            fullNameLabel.text = fullNameString
            if let imageData   = employee.employeeInformation?.imageData {
                employeeImageView.image = UIImage(data: imageData)
            }
            
        }
    }
    
    let backgroundViewCell: UIView = {
        let view                = UIView()
        view.backgroundColor    = .white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let fullNameLabel: UILabel = {
        let label               = UILabel()
        label.text              = "fullName"
        label.font              = UIFont.boldSystemFont(ofSize: 20)
        label.textColor         = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var employeeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "avatar"))//(image: #imageLiteral(resourceName: "Image"))
        //imageView.image = UIImage(imageLiteralResourceName: <#T##String#>)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode           = .scaleAspectFill
        imageView.layer.cornerRadius    = 10//employeeImageView.frame.width / 2
        imageView.clipsToBounds         = true
        imageView.layer.borderColor     = UIColor.darkBlue.cgColor
        imageView.layer.borderWidth     = 2
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor    = .clear
        self.selectionStyle     = .none
        
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraint(){
        
        addSubview(backgroundViewCell)
        NSLayoutConstraint.activate([
            backgroundViewCell.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundViewCell.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            backgroundViewCell.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            backgroundViewCell.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1)
        ])
        
        addSubview(employeeImageView)
        NSLayoutConstraint.activate([
            employeeImageView.heightAnchor.constraint(equalToConstant: 52),
            employeeImageView.widthAnchor.constraint(equalToConstant: 52),
            employeeImageView.leftAnchor.constraint(equalTo: backgroundViewCell.leftAnchor, constant: 8),
            employeeImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        addSubview(fullNameLabel)
        NSLayoutConstraint.activate([
            fullNameLabel.topAnchor.constraint(equalTo: employeeImageView.topAnchor),
            fullNameLabel.bottomAnchor.constraint(equalTo: employeeImageView.bottomAnchor),
            fullNameLabel.leftAnchor.constraint(equalTo: employeeImageView.rightAnchor, constant: 16)
        ])
        
    }

}
