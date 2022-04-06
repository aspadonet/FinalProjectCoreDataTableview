//
//  CreatEmployeeViewController.swift
//  CompanyN
//
//  Created by Alexander Avdacev on 9/15/21.
//  Copyright © 2021 111. All rights reserved.
//

import UIKit


protocol CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee)
    func editEmployee(employee: Employee)
    func deleteFromTable(employee: Employee)
}

class CreateEmployeeController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    let office = [
        EmployeeOffice.director.rawValue,
        EmployeeOffice.manager.rawValue,
        EmployeeOffice.officeWorker.rawValue,
        EmployeeOffice.accountant.rawValue
    ]
    
    private let maxNumberCount = 12
    private let regex = try! NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
    
    
    var employee: Employee? {
        didSet {
            
            guard let employee = employee else {return}
            
            firstNameTextField.text = employee.firstName
            lastNameTextField.text  = employee.lastName
            socialidTextField.text  = employee.socialid
            
            guard  let phoneText    = employee.employeeInformation?.phone else {return}
            
            let dateFormatter       = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            phoneTextField.text     = phoneText
            
            guard  let hiringDate   = employee.employeeInformation?.hiringDate else {return}
            
            hiringDateField.text    = dateFormatter.string(from: hiringDate)
            cityField.text          = employee.address?.city
            
            if let imageData = employee.employeeInformation?.imageData {
                employeeImageView.image = UIImage(data: imageData)
                setupCircularImageStyle()
            }else {
                employeeImageView.image = UIImage(named: "avatar")
            }
            
            guard let houseNoInt = employee.address?.houseNo else {return}
            
            houseNoField.text   = String(houseNoInt)
            streetField.text    = employee.address?.street
            
            guard let employeeType = employee.office else {return}
            
            let index = office.firstIndex(of: employeeType)!
            employeeOfficeSegmentedControl.selectedSegmentIndex = index
            
        }
    }
    
    var delegate: CreateEmployeeControllerDelegate?
    
    let firstNameLabel  = UILabel(text: "First Name")
    let lastNameLabel   = UILabel(text: "Last Name")
    let socialidLabel   = UILabel(text: "Socialid NO")
    let phoneTextLabel  = UILabel(text: "Phone")
    let hiringDateLabel = UILabel(text: "Hiring Date")
    let cityLabel       = UILabel(text: "City")
    let houseNoLabel    = UILabel(text: "HouseNo")
    let streetLabel     = UILabel(text: "Street")
    
    let firstNameTextField  = UITextField(placeholder: "Enter First Name", text: "")
    let lastNameTextField   = UITextField(placeholder: "Enter Last Name", text: "")
    let socialidTextField   = UITextField(placeholder: "Enter Socialid NO", text: "")
    let phoneTextField      = UITextField(placeholder: "Phone", text: "")
    let hiringDateField     = UITextField(placeholder: "MM/dd/yyyy", text: "")
    let cityField           = UITextField(placeholder: "Enter City", text: "")
    let houseNoField        = UITextField(placeholder: "Enter HouseNo", text: "")
    let streetField         = UITextField(placeholder: "Enter Street", text: "")
    
    let employeeOfficeSegmentedControl: UISegmentedControl = {
        
        let office = [
            EmployeeOffice.director.rawValue,
            EmployeeOffice.manager.rawValue,
            EmployeeOffice.officeWorker.rawValue,
            EmployeeOffice.accountant.rawValue
        ]
        
        let segmentedControl = UISegmentedControl(items: office)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.tintColor = UIColor.darkGray
        return segmentedControl
    }()
    
    lazy var employeeImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Image"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectPhoto)))
        return imageView
    }()
    
    @objc func selectPhoto() {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerController delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let edidImage            = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            employeeImageView.image = edidImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            employeeImageView.image = originalImage
        }
        
        setupCircularImageStyle()
        
        dismiss(animated: true, completion: nil)
    }
    // MARK: - setup Circular Image Style
    
    private func setupCircularImageStyle() {
        employeeImageView.layer.cornerRadius = employeeImageView.frame.width / 2
        employeeImageView.clipsToBounds     = true
        employeeImageView.layer.borderColor = UIColor.darkBlue.cgColor
        employeeImageView.layer.borderWidth = 2
    }
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
        setupConstraint()
        firstNameTextField.delegate = self
        lastNameTextField.delegate  = self
        phoneTextField.delegate     = self
        hiringDateField.delegate    = self
        cityField.delegate          = self
        houseNoField.delegate       = self
        streetField.delegate        = self
        phoneTextField.keyboardType = .numberPad
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = employee == nil ? "Create Employee" : "Edit Employee"
    }
    
    // MARK: -
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        var translation:CGFloat = 0
        
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if  houseNoField.isEditing || cityField.isEditing || hiringDateField.isEditing || streetField.isEditing{
                translation = CGFloat(-keyboardSize.height)
                
            }else if firstNameTextField.isEditing || lastNameTextField.isEditing || phoneTextField.isEditing{
                translation = CGFloat(-keyboardSize.height / 3)
                
            }
        }
        UIView.animate(withDuration: 0.2) {
            self.view.transform = CGAffineTransform(translationX: 0, y: translation)
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.2) {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
 
    
    @objc private func handleSave(){
        if employee == nil {
            createEmployee()
        }else {
            saveEmployee()
        }
    }
    
    private func deleteFromTable(){
        self.delegate?.deleteFromTable(employee: self.employee!)
    }
    
    // MARK: - save and create Employee and Validation
    
    private func saveEmployee() {
        
        guard  let employee = employee else {
            return
        }
        guard let city = cityField.text else {return}
        
        if city.isEmpty {
            showError(title: "Empty city", message: "You have not entered a city.")
            return
        }
        
        guard let houseNoString = houseNoField.text else { return }
        
        let houseNo = Int16(houseNoString)
        
        if houseNoString.isEmpty {
            showError(title: "Empty house No", message: "You have not entered a house No.")
            return
        }
        
        guard let street = streetField.text else {return}
        
        if street.isEmpty {
            showError(title: "Empty street", message: "You have not entered to street.")
            return
        }
        
        guard let firstName = firstNameTextField.text else {return}
        
        if firstName.isEmpty {
            showError(title: "Empty first Name", message: "You have not entered a first Name.")
            return
        }
        
        guard let lastName = lastNameTextField.text else { return  }
        
        if lastName.isEmpty {
            showError(title: "Empty last Name", message: "You have not entered a last Name.")
            return
        }
        
        guard let socialid = socialidTextField.text else { return  }
        
        if socialid.isEmpty {
            showError(title: "Empty socialid NO", message: "You have not entered a socialid NO.")
            return
        }
        
        guard let phoneText = phoneTextField.text else { return }
        
        if phoneText.isEmpty || phoneText.count == 1 {
            showError(title: "Empty phone No", message: "You have not entered a phone No.")
            return
        }
        
        guard let hiringDateText = hiringDateField.text else { return }
        
        if hiringDateText.isEmpty {
            showError(title: "Empty hiring day", message: "You have not entered a hiring day.")
            return
        }
        
        let hiringDateFormatter = DateFormatter()
        hiringDateFormatter.dateFormat = "MM/dd/yyyy"
        
        guard let hiringDate = hiringDateFormatter.date(from: hiringDateText) else {
            showError(title: "Bad Date", message: "hiring Date Formatter date entered not valid")
            return
        }
        
//        var employeeImageData: Data?
//        if employeeImageView.image?.jpegData(compressionQuality: 1) != nil
//        {
//            employeeImageData = employeeImageView.image?.jpegData(compressionQuality: 1)
//        } else {
//                        let image = UIImage(named: "avatar")
//                        let data = image?.jpegData(compressionQuality: 0.9)
//                        employeeImageData = data
//        }
        
        var employeeImageData = employeeImageView.image?.pngData()//.jpegData(compressionQuality: 1)
        if employeeImageData == nil {
            let image = UIImage(named: "avatar")
            let data = image?.pngData()
            //let data = image?.jpegData(compressionQuality: 0.9)
            employeeImageData = data
        }
        
        guard let employeeOffice = employeeOfficeSegmentedControl.titleForSegment(at: employeeOfficeSegmentedControl.selectedSegmentIndex) else {return}
        
        deleteFromTable()
        
        let contex = CoreDataManager.shared.persistentContainer.viewContext
        
        employee.firstName                          = firstNameTextField.text
        employee.firstName                          = firstName
        employee.office                             = employeeOffice
        employee.lastName                           = lastName
        employee.socialid                           = socialid
        employee.employeeInformation?.phone         = phoneText
        employee.employeeInformation?.hiringDate    = hiringDate
        employee.employeeInformation?.imageData     = employeeImageData
        employee.address?.city                      = city
        employee.address?.street                    = street
        employee.address?.houseNo                   = houseNo ?? 0
        employee.office = employeeOfficeSegmentedControl.titleForSegment(at: employeeOfficeSegmentedControl.selectedSegmentIndex)
        
        do {
            try contex.save()
        } catch let error {
            print(error.localizedDescription)
        }
        dismiss(animated: true) {
            self.delegate?.editEmployee(employee: self.employee!)
        }
    }
    
    private func createEmployee() {
        
        guard let city = cityField.text else {return}
        
        if city.isEmpty {
            showError(title: "Empty city", message: "You have not entered a city.")
            return
        }
        
        guard let houseNoString = houseNoField.text else { return }
                
        let houseNo = Int16(houseNoString)
        
        if houseNoString.isEmpty {
            showError(title: "Empty house No", message: "You have not entered a house No.")
            return
        }
        
        guard let street = streetField.text else {return}
        
        if street.isEmpty {
            showError(title: "Empty street", message: "You have not entered to street.")
            return
        }
        
        guard let firstName = firstNameTextField.text else {return}
        
        if firstName.isEmpty {
            showError(title: "Empty first Name", message: "You have not entered a first Name.")
            return
        }
        
        guard let lastName = lastNameTextField.text else { return  }
        
        if lastName.isEmpty {
            showError(title: "Empty last Name", message: "You have not entered a last Name.")
            return
        }
        
        guard let socialid = socialidTextField.text else { return  }
        
        if socialid.isEmpty {
            showError(title: "Empty socialid NO", message: "You have not entered a socialid NO.")
            return
        }
        
        guard let phoneText = phoneTextField.text else { return }
        
        if phoneText.isEmpty || phoneText.count == 1 {
            showError(title: "Empty phone No", message: "You have not entered a phone No.")
            return
        }
        
        guard let hiringDateText = hiringDateField.text else { return }
        
        if hiringDateText.isEmpty {
            showError(title: "Empty hiring day", message: "You have not entered a hiring day.")
            return
        }
        
        let hiringDateFormatter = DateFormatter()
        hiringDateFormatter.dateFormat = "MM/dd/yyyy"
        
        guard let hiringDate = hiringDateFormatter.date(from: hiringDateText) else {
            showError(title: "Bad Date", message: "hiring Date Formatter date entered not valid")
            return
        }
        
        //guard let employeeImageData = employeeImageView.image?.jpegData(compressionQuality: 1) else { return }
        
        var employeeImageData = employeeImageView.image?.pngData()//.jpegData(compressionQuality: 1)
        if employeeImageData == nil {
            let image = UIImage(named: "avatar")
            let data = image?.pngData()
            //let data = image?.jpegData(compressionQuality: 0.9)
            employeeImageData = data
            
        }
        
        guard let employeeOffice = employeeOfficeSegmentedControl.titleForSegment(at: employeeOfficeSegmentedControl.selectedSegmentIndex) else {return}
        
        guard let employees = CoreDataManager.shared.createEmployee(employeeName: firstName, lastName: lastName, employeeOffice: employeeOffice, phone: phoneText, hiringDate: hiringDate, imageData: employeeImageData, city: city, street: street, houseNo: houseNo, socialid: socialid) else { return  }
        
        
        let selectedIndex = self.tabBarController?.selectedIndex
        if selectedIndex == 1{
            let alert = UIAlertController(title: "save", message: "save", preferredStyle: .alert)
            let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        dismiss(animated: true, completion: {[weak self] in
            self?.delegate?.didAddEmployee(employee: employees)
        })
    }
    
    // MARK: - format phoneNumber
    
    private func format(phoneNumber: String, shouldRemoveLastDigit: Bool) -> String {
        guard !(shouldRemoveLastDigit && phoneNumber.count <= 2) else { return "+" }
        
        let range = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: [], range: range, withTemplate: "")
        
        if number.count > maxNumberCount {
            let maxIndex = number.index(number.startIndex, offsetBy: maxNumberCount)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        if shouldRemoveLastDigit {
            let maxIndex = number.index(number.startIndex, offsetBy: number.count - 1)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        let maxIndex = number.index(number.startIndex, offsetBy: number.count)
        let regRange = number.startIndex..<maxIndex
        
        if number.count < 7 {
            let pattern = "(\\d{3})(\\d{2})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3", options: .regularExpression, range: regRange)
        } else {
            let pattern = "(\\d{3})(\\d{2})(\\d{3})(\\d{2})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3-$4-$5", options: .regularExpression, range: regRange)
        }
        
        return "+" + number
    }
    
    // MARK: - show alert Error
    
    private func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - setup сonstraint
    
    private func setupConstraint(){
        
        view.addSubview(employeeImageView)
        
        NSLayoutConstraint.activate([
            employeeImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            employeeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            employeeImageView.heightAnchor.constraint(equalToConstant: 100),
            employeeImageView.widthAnchor.constraint(equalToConstant: 100)
            
        ])
        
        view.addSubview(firstNameLabel)
        
        NSLayoutConstraint.activate([
            firstNameLabel.topAnchor.constraint(equalTo: employeeImageView.bottomAnchor, constant: 2),
            firstNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            firstNameLabel.widthAnchor.constraint(equalToConstant: 120),
            firstNameLabel.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        view.addSubview(firstNameTextField)
        
        NSLayoutConstraint.activate([
            firstNameTextField.leftAnchor.constraint(equalTo: firstNameLabel.rightAnchor, constant: 8),
            firstNameTextField.bottomAnchor.constraint(equalTo: firstNameLabel.bottomAnchor),
            firstNameTextField.topAnchor.constraint(equalTo: firstNameLabel.topAnchor),
            firstNameTextField.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        view.addSubview(lastNameLabel)
        
        NSLayoutConstraint.activate([
            lastNameLabel.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 0),
            lastNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            lastNameLabel.widthAnchor.constraint(equalToConstant: 120),
            lastNameLabel.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        view.addSubview(lastNameTextField)
        
        NSLayoutConstraint.activate([
            lastNameTextField.leftAnchor.constraint(equalTo: lastNameLabel.rightAnchor, constant: 8),
            lastNameTextField.bottomAnchor.constraint(equalTo: lastNameLabel.bottomAnchor),
            lastNameTextField.topAnchor.constraint(equalTo: lastNameLabel.topAnchor),
            lastNameTextField.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        view.addSubview(socialidLabel)
        
        NSLayoutConstraint.activate([
            socialidLabel.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: 0),
            socialidLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            socialidLabel.widthAnchor.constraint(equalToConstant: 120),
            socialidLabel.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        view.addSubview(socialidTextField)
        
        NSLayoutConstraint.activate([
            socialidTextField.leftAnchor.constraint(equalTo: socialidLabel.rightAnchor, constant: 8),
            socialidTextField.bottomAnchor.constraint(equalTo: socialidLabel.bottomAnchor),
            socialidTextField.topAnchor.constraint(equalTo: socialidLabel.topAnchor),
            socialidTextField.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        view.addSubview(phoneTextLabel)
        
        NSLayoutConstraint.activate([
            phoneTextLabel.topAnchor.constraint(equalTo: socialidLabel.bottomAnchor, constant: 0),
            phoneTextLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            phoneTextLabel.widthAnchor.constraint(equalToConstant: 120),
            phoneTextLabel.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        view.addSubview(phoneTextField)
        
        NSLayoutConstraint.activate([
            phoneTextField.leftAnchor.constraint(equalTo: phoneTextLabel.rightAnchor, constant: 8),
            phoneTextField.bottomAnchor.constraint(equalTo: phoneTextLabel.bottomAnchor),
            phoneTextField.topAnchor.constraint(equalTo: phoneTextLabel.topAnchor),
            phoneTextField.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        view.addSubview(hiringDateLabel)
        
        NSLayoutConstraint.activate([
            hiringDateLabel.topAnchor.constraint(equalTo: phoneTextLabel.bottomAnchor, constant: 0),
            hiringDateLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            hiringDateLabel.widthAnchor.constraint(equalToConstant: 120),
            hiringDateLabel.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        view.addSubview(hiringDateField)
        
        NSLayoutConstraint.activate([
            hiringDateField.leftAnchor.constraint(equalTo: hiringDateLabel.rightAnchor, constant: 8),
            hiringDateField.bottomAnchor.constraint(equalTo: hiringDateLabel.bottomAnchor),
            hiringDateField.topAnchor.constraint(equalTo: hiringDateLabel.topAnchor),
            hiringDateField.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        view.addSubview(cityLabel)
        
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: hiringDateLabel.bottomAnchor, constant: 0),
            cityLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            cityLabel.widthAnchor.constraint(equalToConstant: 120),
            cityLabel.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        view.addSubview(cityField)
        
        NSLayoutConstraint.activate([
            cityField.leftAnchor.constraint(equalTo: cityLabel.rightAnchor, constant: 8),
            cityField.bottomAnchor.constraint(equalTo: cityLabel.bottomAnchor),
            cityField.topAnchor.constraint(equalTo: cityLabel.topAnchor),
            cityField.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        view.addSubview(streetLabel)
        
        NSLayoutConstraint.activate([
            streetLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 0),
            streetLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            streetLabel.widthAnchor.constraint(equalToConstant: 120),
            streetLabel.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        view.addSubview(streetField)
        
        NSLayoutConstraint.activate([
            streetField.leftAnchor.constraint(equalTo: streetLabel.rightAnchor, constant: 8),
            streetField.bottomAnchor.constraint(equalTo: streetLabel.bottomAnchor),
            streetField.topAnchor.constraint(equalTo: streetLabel.topAnchor),
            streetField.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        view.addSubview(houseNoLabel)
        
        NSLayoutConstraint.activate([
            houseNoLabel.topAnchor.constraint(equalTo: streetLabel.bottomAnchor, constant: 0),
            houseNoLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            houseNoLabel.widthAnchor.constraint(equalToConstant: 120),
            houseNoLabel.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        view.addSubview(houseNoField)
        
        NSLayoutConstraint.activate([
            houseNoField.leftAnchor.constraint(equalTo: houseNoLabel.rightAnchor, constant: 8),
            houseNoField.bottomAnchor.constraint(equalTo: houseNoLabel.bottomAnchor),
            houseNoField.topAnchor.constraint(equalTo: houseNoLabel.topAnchor),
            houseNoField.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        view.addSubview(employeeOfficeSegmentedControl)
        
        NSLayoutConstraint.activate([
            employeeOfficeSegmentedControl.topAnchor.constraint(equalTo: houseNoLabel.bottomAnchor, constant: 0),
            employeeOfficeSegmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            employeeOfficeSegmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            employeeOfficeSegmentedControl.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    
}

// MARK: - extension UITextFieldDelegate

extension CreateEmployeeController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if phoneTextField.isEditing{
            let fullString = (textField.text ?? "") + string
            textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: range.length == 1)
            return false
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
