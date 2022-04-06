//
//  EmployeeController.swift
//  CompanyN
//
//  Created by Alexander Avdacev on 9/28/21.
//  Copyright © 2021 111. All rights reserved.
//

import UIKit
import CoreData

class EmployeeController: UIViewController, UITableViewDelegate, UITableViewDataSource, ListEmployeeTableViewControllerDelegate {
    let reuseIdentifier = "cellId"
    var emplTemp: [Employee]?
    let tableView = UITableView()
    var customHeaderView: UIView?
    var employeelist = [Employee]()
    var employees: [Employee]?
    var employee: Employee?
    {
        didSet {
            createEmployeeList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        navigationItem.title = employee?.firstName ?? "About Employee"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "add", style: .plain, target: self, action: #selector(addwork))
        
        setupTableView()
        setupConstraint()
        
    }
    
    
    // MARK: - setup TableView
    
    func setupTableView(){
        tableView.dataSource             = self
        tableView.delegate               = self
        self.tableView.backgroundColor   = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        self.tableView.separatorStyle    = .none
        tableView.register(ListEmployeeTableViewCell.self,
                           forCellReuseIdentifier: reuseIdentifier)
        tableView.allowsSelection           = true
        tableView.bounces                   = false
        tableView.isUserInteractionEnabled  = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?  {
        let customHeaderView        = CustomHeaderView()
        customHeaderView.employee   = employee
        return customHeaderView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(employeelist.count)
        return employeelist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                 for: indexPath) as! ListEmployeeTableViewCell
        let employees = employeelist[indexPath.row]
        cell.employee = employees
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employee                = employeelist[indexPath.row]
        let employeeController      = EmployeeController()
        employeeController.employee = employee
        navigationController?.pushViewController(employeeController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteItem = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _,_,_ in
            guard let self = self else {return}
            
            let employeedel = self.employeelist[indexPath.row]

            self.delManagerList(employeedel: employeedel)
            self.delEmployeelist(employeedel: employeedel)
            self.employeelist.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
           
        }
        
        deleteItem.backgroundColor = .red
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteItem])
        return swipeActions
    }
    
    // MARK: - delete from manager list
    
    func delManagerList(employeedel: Employee){
        let context = CoreDataManager.shared.persistentContainer.viewContext
        guard let list = employeedel.managerList?.allObjects as? [ManagerList] else {return}
        for item in list{
            if item.socialid == self.employee?.socialid{
                employeedel.removeFromManagerList(item)
                context.delete(item)
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
        guard let list = employee?.employeeList?.allObjects as? [EmployeeList] else {return}
        var deletFromContext: EmployeeList
        
        for item in list{
            if item.socialid == employeedel.socialid{
                self.employee?.removeFromEmployeeList(item)
                deletFromContext = item
                context.delete(deletFromContext)
            }
        }
        
        do {
            try context.save()
        } catch let error {
            print("Failed to create employee:", error)
        }
        
        
    }

    // MARK: - save manager and employee lists
    
    func saveManagerList(employee: Employee){
        let contex              = CoreDataManager.shared.persistentContainer.viewContext
        let managerList         = ManagerList(context: contex)
        managerList.socialid    = self.employee?.socialid
        
        managerList.employee    = employee
        CoreDataManager.shared.saveContex()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2){
            
        }
        
    }
    
    func saveEmployeelist(employee: Employee){
        let contex            = CoreDataManager.shared.persistentContainer.viewContext
        let employeeList      = EmployeeList(context: contex)
        employeeList.socialid = employee.socialid
        
        employeeList.employee = self.employee
        CoreDataManager.shared.saveContex()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2){
            
        }
        
    }
    // MARK: - add work button - create ListEmployee TableViewController
    
    @objc func addwork(){
        let createListEmployeeTableViewController      = ListEmployeeTableViewController()
        createListEmployeeTableViewController.delegate = self
        createListEmployeeTableViewController.employee = employee
        let navController                              = UINavigationController(rootViewController:                                                     createListEmployeeTableViewController)
        present(navController, animated: true, completion: nil)
        
    }

    // MARK: - add and create employee list
    
    func addworks(employees: [Employee]){

        for item in employees{
            saveEmployeelist(employee: item)
            saveManagerList(employee: item)
            let row         = employeelist.count
            let indexPath   = IndexPath(row: row, section: 0)
            employeelist.append(item)
            tableView.insertRows(at: [indexPath], with: .middle)
        }
        tableView.reloadData()
    }
    
    func createEmployeeList(){
        guard let list = employee?.employeeList?.allObjects as? [EmployeeList] else {return}
        
        for item in list{
            let predicateEmployee = NSPredicate(format: "socialid == %@", item.socialid!)
            let resultEmployee    = CoreDataManager.shared.getARecord(entityName: "Employee",
                                                                      predicate: predicateEmployee)
            let employeeT         = resultEmployee?.first as! Employee
            employeelist.append(employeeT)
        }        
        tableView.reloadData()
    }
    
    // MARK: - setup constraint
    
    private func setupConstraint(){
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }


}
