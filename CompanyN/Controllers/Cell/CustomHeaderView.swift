//
//  CustomHeaderView.swift
//  CompanyN
//
//  Created by Alexander Avdacev on 9/12/21.
//  Copyright © 2021 111. All rights reserved.
//

import UIKit

class CustomHeaderView: UIView {
    
    var employee: Employee? {
        didSet {
            setupLabels()
        }
    }
    
    let fullNameLabel           = UILabel(text: "First Name")
    let employeeTypeLabel       = UILabel(text: "EmployeeType")
    let phoneTextLabel          = UILabel(text: "Phone")
    let hiringDateLabel         = UILabel(text: "Hiring Date")
    let adressLabel             = UILabel(text: "Adress")
    let customBirthdayLabel     = UILabel(text: "Birthday")
    let customHiringDateLabel   = UILabel(text: "Hiring Date:")
    let customAdressLabel       = UILabel(text: "Adress:")
    let profileImageView        = ProfileImageView(image: #imageLiteral(resourceName: "avatar"))
    
    // MARK: - 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        setupCircularImageStyle()
        setupStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - setup StackView
    
    func setupStackView(){
        let rightSpacerView = UIView()
        let imageStackView  = UIStackView(arrangedSubviews: [profileImageView])
        imageStackView.axis = .vertical

        let arrangedSubviews = [
            UIStackView(arrangedSubviews: [employeeTypeLabel,
                                           SpacerView(space: 16),
                                           fullNameLabel, rightSpacerView]),

            UIStackView(arrangedSubviews: [customHiringDateLabel,
                                           SpacerView(space: 16),
                                           hiringDateLabel]),
            
            UIStackView(arrangedSubviews: [customAdressLabel,
                                           SpacerView(space: 16),
                                           adressLabel])
        ]
        let stackView       = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis      = .vertical
        stackView.spacing   = 4
        
        let stackViewGorizon = UIStackView(arrangedSubviews: [imageStackView,
                                                              stackView,
                                                              UIStackView(arrangedSubviews: [rightSpacerView])])
        stackViewGorizon.spacing        = 16
        stackViewGorizon.alignment      = .center
        stackViewGorizon.distribution   = .equalSpacing
        addSubview(stackViewGorizon)
        stackViewGorizon.translatesAutoresizingMaskIntoConstraints                  = false
        stackViewGorizon.topAnchor.constraint(equalTo: topAnchor).isActive          = true
        stackViewGorizon.leadingAnchor.constraint(equalTo: leadingAnchor).isActive  = true
        stackViewGorizon.bottomAnchor.constraint(equalTo: bottomAnchor).isActive    = true
        stackViewGorizon.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        stackViewGorizon.isLayoutMarginsRelativeArrangement = true
        stackViewGorizon.layoutMargins                      = UIEdgeInsets(top: 24,
                                                                           left: 24,
                                                                           bottom: 24,
                                                                           right: 24)
    }
    // MARK: - setup Circular Image Style
    
    func setupCircularImageStyle(){
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 10//48 / 2
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = .none
        profileImageView.layer.borderColor = UIColor.darkBlue.cgColor
        profileImageView.layer.borderWidth = 2
    }
    // MARK: - setup Labels
    
    func setupLabels(){
        guard let employee  = employee else {return}
        guard let firstName = employee.firstName else {return}
        guard let lastName  = employee.lastName else {return}
        let fullName        = firstName + " " + lastName
        fullNameLabel.text  = fullName
        
        guard  let phoneText = employee.employeeInformation?.phone else {return}
        
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "MM/dd/yy"
        phoneTextLabel.text         = phoneText
        
        guard  let hiringDate   = employee.employeeInformation?.hiringDate else {return}
        hiringDateLabel.text    = dateFormatter.string(from: hiringDate)
        
        guard let city      = employee.address?.city else {return}
        guard let houseNo   = employee.address?.houseNo else {return}
        guard let street    = employee.address?.street else {return}
        adressLabel.text    = city + " " + street + " " + String(houseNo)
        
        if let imageData = employee.employeeInformation?.imageData {
            profileImageView.image = UIImage(data: imageData)
            //setupCircularImageStyle()
        }
        
        guard let employeeType = employee.office else {return}
        employeeTypeLabel.text = employeeType
    }
}
