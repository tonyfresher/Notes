//
//  ListTableViewCell.swift
//  Notes
//
//  Created by Anton Fresher on 13.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    var note: Note! { didSet { updateUI() } }

    @IBOutlet weak var colorSpine: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func updateUI() {
        guard note != nil else {
            return
        }
        
        titleLabel?.text = note.title
        contentLabel?.text = note.content
        colorSpine?.backgroundColor = UIColor.red//note.color
    }
}
