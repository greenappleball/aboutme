//
//  ExperienceCell.swift
//  aboutme
//
//  Created by Dmitri Petrishin on 3/14/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

class ExperienceCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!

    weak var person: Person?
}

extension ExperienceCell: Fillable {
    func fill(by person: Person) -> Void {
        self.person = person
    }
}
