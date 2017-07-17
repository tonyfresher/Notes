//
//  ListTableViewController.swift
//  Notes
//
//  Created by Anton Fresher on 12.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import UIKit
import CocoaLumberjack

class ListTableViewController: UITableViewController, UISplitViewControllerDelegate {
    
    private var notebook = Notebook(from: [Note(title: "Foo1asdasdasdasdasdasdasdasdasdasdasdasd", content: "Barasdasdasdsasdasdasdadesdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdadasdasdasdasdasdasdasd"), Note(title: "Foo2", content: "Bar")])
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        if primaryViewController.contents == self {
            if let noteDetailViewController =
                secondaryViewController.contents as? NoteDetailViewController, noteDetailViewController.state == .blank {
                return true
            }
        }
        
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? notebook.size : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        
        if let noteCell = cell as? ListTableViewCell {
            noteCell.note = notebook[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row < notebook.size
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            do {
                _ = try notebook.remove(with: notebook[indexPath.row].uuid)
            } catch {
                DDLogWarn("Failed while deleting from \(notebook) with UUID: \(notebook[indexPath.row].uuid)")
            }
            tableView.endUpdates()
        }
    }
    
    private let createNewIdentifier = "CreateNote"
    
    private let editNoteIdentifier = "EditNote"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination.contents as? NoteDetailViewController {
            if segue.identifier == createNewIdentifier {
                detailViewController.note = Note()
            } else if segue.identifier == editNoteIdentifier,
                let noteIndex = tableView.indexPathForSelectedRow?.row {
                detailViewController.note = notebook[noteIndex]
            }
        }
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
}

extension UIViewController {
    
    var contents: UIViewController {
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController ?? self
        } else {
            return self
        }
    }
}
