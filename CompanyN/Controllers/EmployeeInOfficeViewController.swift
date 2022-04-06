//
//  EmployeeInOfficeViewController.swift
//  CompanyN
//
//  Created by Alexander Avdacev on 9/13/21.
//  Copyright © 2021 111. All rights reserved.
//

import UIKit
import CoreData



class IndentedLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let insets       = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect   = rect.inset(by: insets)
        super.drawText(in: customRect)
    }
}


class EmployeeInOfficeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView  = UITableView()
    var employees               = [Employee]()
    var allEmployees            = [[Employee]]()
    
    let office = [
        EmployeeOffice.director.rawValue,
        EmployeeOffice.manager.rawValue,
        EmployeeOffice.officeWorker.rawValue,
        EmployeeOffice.accountant.rawValue
    ]
    
    var reuseIdentifier         = "CellIdentifier"
    var headerReuseIdentifier   = "HeaderCellIdentifier"
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor  = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        self.tableView.separatorStyle   = .none
        
//        navigationItem.leftBarButtonItems = [
//            UIBarButtonItem(title: "Delete All",
//                            style: .plain,
//                            target: self,
//                            action: #selector(handleReset))
//        ]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "add",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(handleAdd))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let screenSize: CGRect  = UIScreen.main.bounds
        tableView.bounces       = false
        tableView.frame         = CGRect(x: 0,
                                         y: 0,
                                         width: screenSize.width,
                                         height: screenSize.height)
        tableView.dataSource    = self
        tableView.delegate      = self
        
        tableView.register(EmployeeInOfficeCell.self,
                           forCellReuseIdentifier: reuseIdentifier)
        tableView.register(EmployeeHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: headerReuseIdentifier)
        
        tableView.separatorStyle = .none

        self.view.addSubview(tableView)
        fetchEmployee()
        self.tableView.reloadData()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - handle Button
    
    @objc func handleReset() {
        
        let context            = CoreDataManager.shared.persistentContainer.viewContext
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Employee.fetchRequest())
        
        do {
            try context.execute(batchDeleteRequest)
            
            var indexPathsToRemove = [IndexPath]()
            
            for (section, _) in allEmployees.enumerated() {
                
                for (index, _) in allEmployees[section].enumerated(){
                    let indexPath = IndexPath(row: index,
                                              section: section)
                    indexPathsToRemove.append(indexPath)
                    
                }
                allEmployees[section].removeAll()
                tableView.deleteRows(at: indexPathsToRemove,
                                     with: .left)
                indexPathsToRemove.removeAll()
            }
            
        } catch let Error {
            print("Failed to delete objects from Core Data:", Error)
        }
    }
    
    @objc func handleAdd(){
        let createEmployeeController      = CreateEmployeeController()
        createEmployeeController.delegate = self
        let navController = UINavigationController(rootViewController: createEmployeeController)
        present(navController, animated: true, completion: nil)
        
    }
    
    // MARK: - fetch employee
    
    func fetchEmployee() {
        self.employees = CoreDataManager.shared.fetchAllEmployees()
        
        allEmployees = []
        
        if self.employees.count == 0 {
            EmployeeData.createFinal()
            self.employees = CoreDataManager.shared.fetchAllEmployees()
        }
        
        office.forEach { (office) in
            allEmployees.append(
                employees.filter { $0.office == office }
            )
        }
    }
    
    
    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseIdentifier) as? EmployeeHeaderView
        header?.headerLabel.text = office[section]
        return header
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employee                = self.allEmployees[indexPath.section][indexPath.row]
        let employeeController      = EmployeeController()
        employeeController.employee = employee
        navigationController?.pushViewController(employeeController,
                                                 animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteItem = UIContextualAction(style: .destructive,
                                            title: "Delete") {  [weak self]_,_,_ in
            let context          = CoreDataManager.shared.persistentContainer.viewContext
            guard let self       = self else {return}
            let employee         = self.allEmployees[indexPath.section][indexPath.row]
            self.allEmployees[indexPath.section].remove(at: indexPath.row)
            let indexPath        = IndexPath(row: indexPath.row, section: indexPath.section)
            self.tableView.deleteRows(at: [indexPath], with: .left)
            self.delManagerList(employeedel: employee)
            self.delEmployeelist(employeedel: employee)
            context.delete(employee)
            CoreDataManager.shared.saveContex()
            
        }
        
        deleteItem.backgroundColor = .red
        
        let editAction = UIContextualAction(style: .normal, title: "Edit"){  [weak self]_,_,_ in
            guard let self = self else {return}
            let editEmployeeController      = CreateEmployeeController()
            editEmployeeController.delegate = self
            let employee                    = self.allEmployees[indexPath.section][indexPath.row]
            editEmployeeController.employee = employee
            
            let navVC = UINavigationController(rootViewController: editEmployeeController)
            
            self.present(navVC, animated: true, completion: nil)
            
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteItem, editAction])
        
        return swipeActions
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  allEmployees[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                 for: indexPath) as! EmployeeInOfficeCell
        cell.employee = allEmployees[indexPath.section][indexPath.row] 
        return cell 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // MARK: - delete from manager list
    
    func delManagerList(employeedel: Employee){
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        guard let list = employeedel.managerList?.allObjects as? [ManagerList] else {return}
        
        for item in list{
            
            guard let socialid       = item.socialid else { return }
            
            let predicate            = NSPredicate(format: "socialid == %@",
                                                   socialid)
            let result               = CoreDataManager.shared.getARecord(entityName: "Employee",
                                                                        predicate: predicate)
            let employeeDelete = result?.first as! Employee
            guard let listItem = employeeDelete.employeeList?.allObjects as? [EmployeeList] else {return}
            for itemtwo in listItem{
                if  itemtwo.socialid == employeedel.socialid{
                    employeeDelete.removeFromEmployeeList(itemtwo)
                    context.delete(item)
                }
            }
        }
        do {
            try context.save()
        } catch let error {
            print("Failed to create employee:", error)
        }
        
    }
    
    // MARK: - delete from employee list
    
    func delEmployeelist(employeedel: Employee)
    {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        guard let list = employeedel.employeeList?.allObjects as? [EmployeeList] else {return}
        for item in list{
            
            guard let socialid   = item.socialid else { return }
            
            let predicate        = NSPredicate(format: "socialid == %@", socialid)
            let result           = CoreDataManager.shared.getARecord(entityName: "Employee",
                                                                     predicate: predicate)
            let employeeDelete   = result?.first as! Employee
            guard let listItem   = employeeDelete.managerList?.allObjects as? [ManagerList] else {return}
            
            for itemtwo in listItem{
                if  itemtwo.socialid == employeedel.socialid{
                    employeeDelete.removeFromManagerList(itemtwo)
                    context.delete(item)
                }
            }
        }
        do {
            try context.save()
        } catch let error {
            print("Failed to create employee:", error)
        }
    }
}

// MARK: - extension EmployeeInOfficeViewController: CreateEmployeeControllerDelegate
extension EmployeeInOfficeViewController: CreateEmployeeControllerDelegate {
    func deleteFromTable(employee: Employee) {
        
        var indexRow: Int?        
        guard let section = office.firstIndex(of: employee.office!) else { return }
        for (index, value) in allEmployees[section].enumerated(){
            if value.firstName == employee.firstName{
                indexRow = index
            }
        }
        let row = indexRow!
        allEmployees[section].remove(at: indexRow!)
        let indexPath = IndexPath(row: row, section: section)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
    }
    
    func editEmployee(employee: Employee) {
        
        guard let section = office.firstIndex(of: employee.office!) else { return }
        
        allEmployees[section].append(employee)
        
        let row          = allEmployees[section].count - 1
        let indexPath    = IndexPath(row: row, section: section)
        
        tableView.insertRows(at: [indexPath], with: .middle)
        
    }
    
    func didAddEmployee(employee: Employee) {
        
        guard let section    = office.firstIndex(of: employee.office!) else { return }
        let row              = allEmployees[section].count
        let indexPath        = IndexPath(row: row, section: section)
        
        allEmployees[section].append(employee)
        tableView.insertRows(at: [indexPath], with: .middle)
        
    }
}

