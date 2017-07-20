//
//  Variables.swift
//  Notes
//
//  Created by Anton Fresher on 19.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import UIKit
@testable import Notes

class Variables {
    
    class var notes: [Note] {
        return [
            Note(title: "Foo0", content: "Bar"),
            Note(title: "Foo1", content: "Bar", color: Note.defaultColor),
            Note(title: "Foo2", content: "Bar", color: UIColor(hex: "00000000")!),
            Note(title: "Foo3", content: "Bar", erasureDate: Date()),
            Note(title: "Foo4", content: "Bar", color: UIColor(hex: "00000000")!, erasureDate: Date())
        ]
    }
    
    class var notebook: Notebook {
        return Notebook(from: [
            Note(title: "Foo0", content: "Bar"),
            Note(title: "Foo1", content: "Bar", color: Note.defaultColor),
            Note(title: "Foo2", content: "Bar", color: UIColor(hex: "00000000")!),
            Note(title: "Foo3", content: "Bar", erasureDate: Date()),
            Note(title: "Foo4", content: "Bar", color: UIColor(hex: "00000000")!, erasureDate: Date())
            ])
    }

}
