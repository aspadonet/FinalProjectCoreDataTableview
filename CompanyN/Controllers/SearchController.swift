//
//  SearchController.swift
//  CompanyN
//
//  Created by Alexander Avdacev on 9/23/21.
//  Copyright © 2021 111. All rights reserved.
//

import UIKit

import CoreData

class SearchController: EmployeeInOfficeViewController {
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    var filteredResults = [[Employee]]()
    
    fileprivate let enterSearchTermLabel: UILabel = {
        let label           = UILabel()
        label.text          = "Please enter search term above..."
        label.textAlignment = .center
        label.font          = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    // MARK: - 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
    }
    
    fileprivate func setupSearchBar() {
        definesPresentationContext                        = true
        navigationItem.searchController                   = self.searchController
        navigationItem.hidesSearchBarWhenScrolling        = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate               = self
    }
}

// MARK: -

extension SearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            fetchEmployee()
            tableView.reloadData()
            return
        }
        
        allEmployees = allEmployees.map({ (group) -> [Employee] in
            return group.filter{ $0.firstName?.lowercased().contains(searchText.lowercased()) as! Bool}
        })
        
        tableView.reloadData()
    }
}
