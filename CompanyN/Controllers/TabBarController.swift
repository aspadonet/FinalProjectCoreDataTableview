//
//  TabBarController.swift
//  CompanyN
//
//  Created by 111 on 9/10/21.
//  Copyright © 2021 111. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
        creatNavigationController(viewController: EmployeeInOfficeViewController(), title: "List", imageName: "List"),
        creatNavigationController(viewController: CreateEmployeeController(), title: "ADD&DEL", imageName: "ADD&DEL"),
        creatNavigationController(viewController: SearchController(), title: "Search", imageName: "Search")
        ]
    }
    
    // MARK: - creat navigation controller
    
    private func creatNavigationController (viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.title = title
        viewController.view.backgroundColor = .white
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = UIImage(named: imageName)
        return navigationController
    }
    

}
