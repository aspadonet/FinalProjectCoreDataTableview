//
//  ListEmployeeTableViewController.swift
//  CompanyN
//
//  Created by Alexander Avdacev on 9/25/21.
//  Copyright © 2021 111. All rights reserved.
//

import UIKit

protocol ListEmployeeTableViewControllerDelegate {
    func addworks(employees: [Employee])
}

class ListEmployeeTableViewController: UITableViewController {
    let reuseIdentifier = "cellId"
    var employee: Employee?
    var employees = [Employee]()
    var delegate: ListEmployeeTableViewControllerDelegate?
    var selectionEmployees = [Employee]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEmployee()
        tableView.register(ListEmployeeTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.allowsMultipleSelection = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(selection))
        self.tableView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        self.tableView.separatorStyle = .none 
    }
    
    // MARK: - fetchAllEmployees
    
    func getEmployee(){
        var employeesAll = CoreDataManager.shared.fetchAllEmployees()
        guard let employee = employee else { return }
        guard let indexEmployee = employeesAll.firstIndex(of: employee) else { return  }
        employeesAll.remove(at: indexEmployee)
        
        guard let employeList = employee.employeeList?.allObjects as? [EmployeeList] else { return}
        
        for item in employeList {
            
            guard let socialid = item.socialid else { return }
            let predicate = NSPredicate(format: "socialid == %@", socialid)
            let result = CoreDataManager.shared.getARecord(entityName: "Employee", predicate: predicate)
            let employeeDelete = result?.first as! Employee
            guard let indexEmployee = employeesAll.firstIndex(of: employeeDelete) else { return  }
            employeesAll.remove(at: indexEmployee)
        }
        
        guard let managerList = employee.managerList?.allObjects as? [ManagerList] else { return }
        
        for item in managerList {
            guard let socialid = item.socialid else { return }
            let predicate = NSPredicate(format: "socialid == %@", socialid)
            let result = CoreDataManager.shared.getARecord(entityName: "Employee", predicate: predicate)
            let employeeDelete = result?.first as! Employee
            guard let indexEmployee = employeesAll.firstIndex(of: employeeDelete) else { return  }
            employeesAll.remove(at: indexEmployee)
        }
        
        self.employees = employeesAll
    }
    
    // MARK: - selection employees
    
    @objc func selection(){
        
        selectionEmployees.removeAll()
        
        if let selectedRows = tableView.indexPathsForSelectedRows
        {
            for indexPath in selectedRows{
                selectionEmployees.append(employees[indexPath.row])
            }
            for item in selectionEmployees{
                print(item.firstName!)
            }
            dismiss(animated: true) {
                self.delegate?.addworks(employees: self.selectionEmployees)
            }
        }
        
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                 for: indexPath) as! ListEmployeeTableViewCell
        let employee        = employees[indexPath.row]
        cell.employee       = employee
        cell.selectionStyle = .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    
    // MARK: - Navigation
    
    
}
