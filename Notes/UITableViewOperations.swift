//
//  UITableViewOperations.swift
//  Notes
//
//  Created by Anton Fresher on 24.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import UIKit

class UITableViewOperations {
    
    static func reload(tableView: UITableView) -> Operation {
        return BlockOperation {
            tableView.beginUpdates()
            tableView.reloadData()
            tableView.endUpdates()
        }
    }
    
    static func reload(in tableView: UITableView, at indexPaths: [IndexPath]) -> Operation {
        return BlockOperation {
            tableView.beginUpdates()
            tableView.reloadRows(at: indexPaths, with: .fade)
            tableView.endUpdates()
        }
    }
    
    static func insert(to tableView: UITableView, at indexPaths: [IndexPath]) -> Operation {
        return BlockOperation {
            tableView.beginUpdates()
            tableView.insertRows(at: indexPaths, with: .fade)
            tableView.endUpdates()
        }
    }
    
    static func delete(from tableView: UITableView, at indexPaths: [IndexPath]) -> Operation {
        return BlockOperation {
            tableView.beginUpdates()
            tableView.deleteRows(at: indexPaths, with: .fade)
            tableView.endUpdates()
        }
    }
    
}
