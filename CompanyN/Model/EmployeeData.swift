//
//  EmployeeData.swift
//  CompanyN
//
//  Created by Alexander Avdacev on 8.03.22.
//  Copyright © 2022 111. All rights reserved.
//

import Foundation

class EmployeeData {
    static func createFinal(){
        let model  = EmployeeData.createEmployee()
        EmployeeData.createCoreData(employeeTemp: model)
    }
    
    static func createEmployee() -> [EmployeeTemp]{
        var model = [EmployeeTemp]()
        
        let hiringDateFormatter = DateFormatter()
        hiringDateFormatter.dateFormat = "MM/dd/yyyy"
        
        
        var hiringDate = hiringDateFormatter.date(from: "11/11/11")!
        model.append(EmployeeTemp(firstName: "Ivan",
                                  office: EmployeeOffice.director.rawValue,
                                  socialid: "9874563210",
                                  lastName: "Andreev",
                                  phone: "+375 (44) 123-12-12",
                                  hiringDate: hiringDate,
                                  imageData: nil,
                                  city: "Minsk",
                                  street: "Nemiga",
                                  houseNo: 155))
        
        hiringDate = hiringDateFormatter.date(from: "05/12/12")!
        model.append(EmployeeTemp(firstName: "Mark",
                                  office: EmployeeOffice.manager.rawValue,
                                  socialid: "1874563210",
                                  lastName: "Nikitin",
                                  phone: "+375 (44) 123-12-12",
                                  hiringDate: hiringDate,
                                  imageData: nil,
                                  city: "Minsk",
                                  street: "Nemiga",
                                  houseNo: 13))
        
        hiringDate = hiringDateFormatter.date(from: "03/13/18")!
        model.append(EmployeeTemp(firstName: "Sergei",
                                  office: EmployeeOffice.manager.rawValue,
                                  socialid: "9274563210",
                                  lastName: "Makarov",
                                  phone: "+375 (44) 123-12-12",
                                  hiringDate: hiringDate,
                                  imageData: nil,
                                  city: "Minsk",
                                  street: "Nemiga",
                                  houseNo: 45))
       
        hiringDate = hiringDateFormatter.date(from: "02/14/15")!
        model.append(EmployeeTemp(firstName: "Kirill",
                                  office: EmployeeOffice.officeWorker.rawValue,
                                  socialid: "9834563210",
                                  lastName: "Vladuko",
                                  phone: "+375 (44) 123-12-12",
                                  hiringDate: hiringDate,
                                  imageData: nil,
                                  city: "Minsk",
                                  street: "Nemiga",
                                  houseNo: 78))
        
        hiringDate = hiringDateFormatter.date(from: "10/15/14")!
        model.append(EmployeeTemp(firstName: "Valera",
                                  office: EmployeeOffice.officeWorker.rawValue,
                                  socialid: "4874563210",
                                  lastName: "Zakharov",
                                  phone: "+375 (44) 123-12-12",
                                  hiringDate: hiringDate,
                                  imageData: nil,
                                  city: "Minsk",
                                  street: "Nemiga",
                                  houseNo: 436))
        
        hiringDate = hiringDateFormatter.date(from: "01/16/11")!
        model.append(EmployeeTemp(firstName: "Vitalii",
                                  office: EmployeeOffice.officeWorker.rawValue,
                                  socialid: "6874563210",
                                  lastName: "Zakharov",
                                  phone: "+375 (44) 123-12-12",
                                  hiringDate: hiringDate,
                                  imageData: nil,
                                  city: "Minsk",
                                  street: "Nemiga",
                                  houseNo: 78))
        
        hiringDate = hiringDateFormatter.date(from: "11/11/11")!
        model.append(EmployeeTemp(firstName: "Anton",
                                  office: EmployeeOffice.accountant.rawValue,
                                  socialid: "9874563555",
                                  lastName: "Solovev",
                                  phone: "+375 (44) 123-12-12",
                                  hiringDate: hiringDate,
                                  imageData: nil,
                                  city: "Minsk",
                                  street: "Nemiga",
                                  houseNo: 1))
        
        return model
    }
    
    static func createCoreData(employeeTemp: [EmployeeTemp]) {
        for emp in employeeTemp{
            
            CoreDataManager.shared.createEmployee(employeeName: emp.firstName,
                                                  lastName: emp.lastName,
                                                  employeeOffice: emp.office,
                                                  phone: emp.phone,
                                                  hiringDate: emp.hiringDate,
                                                  imageData: emp.imageData,
                                                  city: emp.city,
                                                  street: emp.street,
                                                  houseNo: emp.houseNo,
                                                  socialid: emp.socialid)
        }
    }
}
