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
        // Initialization code
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

extension UIImage {
    
    convenience init(withBackground color: UIColor) {
        
        let rect: CGRect = CGRect(x: 0, y: 0, width: 100, height: 100)
        UIGraphicsBeginImageContext(rect.size);
        let context:CGContext = UIGraphicsGetCurrentContext()!;
        context.setFillColor(color.cgColor);
        context.fill(rect)
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.init(ciImage: CIImage(image: image)!)
    }
}
