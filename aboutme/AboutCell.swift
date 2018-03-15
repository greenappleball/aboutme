//
//  AboutCell.swift
//  aboutme
//
//  Created by Dmitri Petrishin on 3/14/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

class AboutCell: UITableViewCell {
    @IBOutlet weak var textView: UITextView!
}

extension AboutCell: Fillable {
    func fill(by person: Person) -> Void {
        textView.text = person.aboutMe
    }
}
