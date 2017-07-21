//
//  ListTableViewController.swift
//  Notes
//
//  Created by Anton Fresher on 12.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import UIKit
import CocoaLumberjack
import CoreData

class ListTableViewController: UITableViewController, UISplitViewControllerDelegate, NSFetchedResultsControllerDelegate {
    
    // MARK: UI
    
    @IBOutlet var listTableView: UITableView!
    
    // MARK: - Properties
    
    private var notebook = Notebook()
    
    private let notebookUUID = "3392911E-D663-46AE-85A9-F1CAA702AFE0"
    
    private lazy var fetchedResultsController: NSFetchedResultsController<NotebookEntity> = {
        let fetchRequest: NSFetchRequest<NotebookEntity> = NotebookEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", self.notebookUUID)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: self.backgroundManagedObjectContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        return fetchedResultsController
    }()
    
    // MARK: Core Data usage
    
    private var coreDataManager: CoreDataManager! {
        didSet { backgroundManagedObjectContext = coreDataManager.createChildManagedObjectContext() }
    }
    
    private var backgroundManagedObjectContext: NSManagedObjectContext!
    
    private func updateNotebook() {
        fetchedResultsController.managedObjectContext.perform {
            do {
                print(NSHomeDirectory())
                try self.fetchedResultsController.performFetch()
                guard let notebookEntitiy = self.fetchedResultsController.fetchedObjects?[0],
                    let notebook = notebookEntitiy.toNotebook() else {
                        fatalError("While loading data from database an error occured")
                }
                self.notebook = notebook
            } catch {
                // MARK: NEED HANDLING
                DDLogError("Error while fetching NotebookEntity: \(error.localizedDescription)")
            }
        }
    }
    
    func add(note: Note) {
        notebook.add(note: note)
        
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        self.tableView.endUpdates()
    }
    
    func update(note: Note, on indexPath: IndexPath) {
        
        notebook[indexPath.row] = note
        
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [indexPath], with: .fade)
        self.tableView.endUpdates()
    }
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        coreDataManager = (UIApplication.shared.delegate as! AppDelegate).coreDataManager
        
        self.splitViewController?.delegate = self
        self.fetchedResultsController.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Configuring UI
        splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        updateNotebook()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: Segues control
    
    static let createNoteSegueIdentifier = "CreateNote"
    
    static let editNoteSegueIdentifier = "EditNote"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination.contents as? DetailViewController {
            if segue.identifier == ListTableViewController.createNoteSegueIdentifier {
                detailViewController.note = Note()
            } else if segue.identifier == ListTableViewController.editNoteSegueIdentifier,
                let noteIndex = tableView.indexPathForSelectedRow?.row {
                detailViewController.note = notebook[noteIndex]
            }
        }
    }
    
    // MARK: UITableViewDataSource implementation
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? notebook.size : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath)
        
        guard let noteCell = cell as? ListTableViewCell else { return cell }
        
        // MARK: Reverse list due to optimisation
        noteCell.note = notebook[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row < notebook.size
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            tableView.beginUpdates()
            // _ = notebook.remove(at: indexPath.row)
            // TODO: MAKE POPUP VIEW
            tableView.deleteRows(at: [indexPath], with: .fade)
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
    
    // MARK: UISplitViewController stuff
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        if primaryViewController.contents == self {
            if let noteDetailViewController =
                secondaryViewController.contents as? DetailViewController, noteDetailViewController.state == .blank {
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
