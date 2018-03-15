//
//  GeneralViewModel.swift
//  aboutme
//
//  Created by Dmitri Petrishin on 3/14/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit
import RealmSwift

enum Section: Int {
    case person = 0
    case experience = 1
    case about = 2

    init?(rawValue: Int) {
        switch rawValue {
        case 0: self = .person
        case 1: self = .experience
        case 2: self = .about
        default: return nil
        }
    }

    var identifier: String {
        switch self {
        case .person: return "PersonCell"
        case .experience: return "ExperienceCell"
        case .about: return "AboutCell"
        }
    }
    
}

enum CardType {
    case add
    case card

    var identifier: String {
        switch self {
        case .add: return "AddCell"
        case .card: return "CardCell"
        }
    }
    var size: CGSize {
        switch self {
        case .add: return CGSize(width: 80, height: 138)
        case .card: return CGSize(width: 242, height: 138)
        }
    }
}

class GeneralViewModel: NSObject {
    var person = Person()
    var experience: List<Experience> {
        return person.experience
    }

    fileprivate let primaryKeyValue = "0"

    // MARK:
    override init() {
        if let found = RealmManager.shared.read(Person.self, forPrimaryKey: primaryKeyValue) {
            person = found
        } else {
            // first time
            person.id = primaryKeyValue
            person.create()
        }
    }
}
