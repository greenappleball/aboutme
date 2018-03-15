//
//  CardCell.swift
//  aboutme
//
//  Created by Dmitri Petrishin on 3/15/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    @IBOutlet weak var organizationLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var responsibilityLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
}

extension CardCell: Fillable {
    func fill(by model: Experience) {
        organizationLabel.text = model.organization
        positionLabel.text = model.position
        responsibilityLabel.text = model.responsibility
        periodLabel.text = model.period
    }
}
