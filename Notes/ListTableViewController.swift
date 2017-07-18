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
    
    private var notebook = Notebook(from: [
        Note(title: "Lorem ipsum", content: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
        Note(title: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", content: "Lorem ipsum")])
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.splitViewController?.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
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
    
    // MARK: TableView stuff
    
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
            do {
                _ = try notebook.remove(with: notebook[indexPath.row].uuid)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                DDLogWarn("Failed while deleting from \(notebook) with UUID: \(notebook[indexPath.row].uuid)")
            }
            tableView.endUpdates()
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
    
    // MARK: SplitViewController stuff
    
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
}

extension UIViewController {
    
    fileprivate var contents: UIViewController {
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController ?? self
        } else {
            return self
        }
    }
}
