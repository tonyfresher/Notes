//
//  ListTableViewCell.swift
//  Notes
//
//  Created by Anton Fresher on 13.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    // PART: - UI

    @IBOutlet weak var colorSpine: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    // PART: - Properties
    
    static let reuseIdentifier = "Note"
    
    var note: Note! { didSet { updateUI() } }

    private func updateUI() {
        guard note != nil else { return }
        
        titleLabel?.text = note.title
        contentLabel?.text = note.content
        colorSpine?.backgroundColor = UIColor.red // MARK: change to note.color
    }
    
}
