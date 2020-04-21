//
//  SideMenuTableViewController.swift
//  Capstone_HomeDecor
//
//  Created by Harmanpreet Kaur on 2020-04-14.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit

enum MenuType: Int {
    case home
    case addNewObject
    case logout
}

class SideMenuTableViewController: UITableViewController {
    
    var didTapMenuType: ((MenuType) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else { return }
        dismiss(animated: true) {
            print("Dismissing \(menuType.rawValue)")
            if menuType.rawValue == 1{
                Constants.FILENAME = UUID().uuidString
            }
            self.didTapMenuType?(menuType)
        }
    }    
}
