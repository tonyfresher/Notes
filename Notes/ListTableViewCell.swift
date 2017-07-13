//
//  ListTableViewCell.swift
//  Notes
//
//  Created by Anton Fresher on 13.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    var note: Note? { didSet { updateUI() } }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func updateUI() {
        
    }

}
