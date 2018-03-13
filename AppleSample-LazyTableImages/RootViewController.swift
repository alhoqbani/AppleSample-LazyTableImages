//
//  RootViewController.swift
//  AppleSample-LazyTableImages
//
//  Created by Hamoud Alhoqbani on 3/13/18.
//  Copyright © 2018 Hamoud Alhoqbani. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController {
    
    var entries = [AppRecord]()
    
    enum cellsIdentifier: String {
        case LazyTableCell
        case PlaceholderCell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count == 0 ? 1 : entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        
        if entries.count == 0 && indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: cellsIdentifier.PlaceholderCell.rawValue, for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: cellsIdentifier.LazyTableCell.rawValue, for: indexPath)
            
            if entries.count > 0 {
                let appRecord = entries[indexPath.row]
                cell.textLabel?.text = appRecord.appName
                cell.detailTextLabel?.text = appRecord.artist
            }
            
        }
        
        return cell
    }
    
}
