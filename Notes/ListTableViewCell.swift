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
    
    @IBOutlet weak var cellImageView: UIImageView!

    @IBOutlet weak var cellTitleLabel: UILabel!
    
    @IBOutlet weak var cellContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func updateUI() {
        guard note != nil else {
            return
        }
        
        cellTitleLabel?.text = note.title
        cellContentLabel?.text = note.content
        cellImageView?.backgroundColor = UIColor.red//UIImage(withBackground: UIColor.red)//UIColor.red//note.color
    }
}
