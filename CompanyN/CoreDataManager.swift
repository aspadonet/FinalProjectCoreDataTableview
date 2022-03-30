//
//  CoreDataManager.swift
//  CompanyN
//
//  Created by 111 on 9/13/21.
//  Copyright © 2021 111. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CompanyModel")
        container.loadPersistentStores { (nsPersistentStoreDescription, error) in
            if let error = error {
                fatalError("Loading of store failed: \(error)")
            }
        }
        
        return container
    }()
    
    func fetchAllEmployees() -> [Employee] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
        do {
            let employees = try context.fetch(fetchRequest)
            return employees
        } catch let error {
            print("Failed to fetch companies:", error)
            return []
        }
    }
    
    func saveContex(){
        
        let context = persistentContainer.viewContext
        if context.hasChanges{
            do {
                try context.save()
                
            } catch let error {
                print("Failed to create employee:", error)
                
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2){
            print("save")
        }
    }
    
    func createEmployee(employeeName: String, lastName: String, employeeOffice: String, phone: String, hiringDate: Date?, imageData: Data?, city: String?, street: String?, houseNo: Int16?, socialid: String) -> Employee? {
        
        let context = persistentContainer.viewContext
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee

        
        employee.firstName = employeeName
        employee.office = employeeOffice
        employee.socialid = socialid
        employee.lastName = lastName
        
        let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
        
        employeeInformation.phone = phone
        employeeInformation.hiringDate = hiringDate
        employeeInformation.imageData = imageData
        
        employee.employeeInformation = employeeInformation
        
        let address = NSEntityDescription.insertNewObject(forEntityName: "Address", into: context) as! Address
        
        address.city = city
        address.street = street
        address.houseNo = houseNo ?? 0
        
        employee.address = address

        
        do {
            try context.save()
            return employee
            
        } catch let error {
            print("Failed to create employee:", error)
            return nil
        }
        
    }
    
    typealias CoreDataBackgroundTask = (NSManagedObjectContext) -> Void
    
    
    
    static var privateContext: NSManagedObjectContext = CoreDataManager.shared.persistentContainer.newBackgroundContext()
    
    
    public static var mainContext: NSManagedObjectContext = CoreDataManager.shared.persistentContainer.viewContext
    
    public static var context: NSManagedObjectContext = CoreDataManager.shared.persistentContainer.viewContext
}


extension CoreDataManager{
    // Use this for reading. Because changes are written directly to disk and it has no parent context
    static func performBackgroundTask(task:@escaping CoreDataBackgroundTask){
        CoreDataManager.shared.persistentContainer.performBackgroundTask(task)
    }
    
    // MARK: - Core Data Saving support
    func saveAllContext(shouldBlock:Bool = true){
        self.savePrivateContext(shouldBlock: shouldBlock)
        self.saveMainContext(shouldBlock: shouldBlock)
    }
    
    func savePrivateContext(shouldBlock:Bool){
        self.saveContext(context: CoreDataManager.privateContext,shouldBlock:shouldBlock)
    }
    
    func saveMainContext(shouldBlock:Bool){
        self.saveContext(context: CoreDataManager.mainContext,shouldBlock:shouldBlock)
    }
    
    func saveContext(context:NSManagedObjectContext,shouldBlock:Bool){
        if context.hasChanges || true {
            if shouldBlock{
                context.performAndWait {
                    self.saveContext(context: context)
                }
            }
            else{
                context.perform {
                    self.saveContext(context: context)
                }
            }
        }
    }
    
    func saveContext(context:NSManagedObjectContext){
        do{
            try context.save()
            print("Saved Private context")
        }
        catch{
            print("\nError in saving core data private context. \(error.localizedDescription)\n")
        }
    }
    
    
    
}

extension CoreDataManager{
    
    func create(entityName : String,context:NSManagedObjectContext = CoreDataManager.privateContext) -> NSManagedObject{
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
    }
    
    func getAllRecords(entityName: String, predicate : NSPredicate?) -> [NSManagedObject]?{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if let predicate = predicate{
            fetchRequest.predicate = predicate
        }
        do{
            guard let records = try CoreDataManager.privateContext.fetch(fetchRequest) as? [NSManagedObject] else {
                return nil
            }
            return records
        }
        catch{
            return nil
        }
    }
    
    func getARecord(entityName: String, predicate : NSPredicate?) -> [NSManagedObject]?{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if let predicate = predicate{
            fetchRequest.predicate = predicate
            fetchRequest.fetchLimit = 1
        }
        do{
            guard let records = try CoreDataManager.context.fetch(fetchRequest) as? [NSManagedObject] else {
                return nil
            }
            return records
        }
        catch{
            return nil
        }
    }
    
    func getCountOfRecords(entityName: String, predicate : NSPredicate?) -> Int?{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if let predicate = predicate{
            fetchRequest.predicate = predicate
        }
        do{
            let recordsCount = try CoreDataManager.mainContext.count(for: fetchRequest)
            return recordsCount
            
        }
        catch{
            return nil
        }
    }
    
    func deleteData(entityName:String,predicate:NSPredicate) {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = predicate
        let objects = try! CoreDataManager.privateContext.fetch(fetchRequest)
        for obj in objects {
            CoreDataManager.privateContext.delete(obj)
        }
    }
    
    func deleteAllRecords(entity : String)
    {
        
        let context = CoreDataManager.privateContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
    {
        try context.execute(deleteRequest)
        CoreDataManager.shared.saveAllContext()
    }
        catch
        {
            print ("There was an error")
        }
    }
}
