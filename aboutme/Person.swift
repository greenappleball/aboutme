//
//  Person.swift
//  aboutme
//
//  Created by Dmitri Petrishin on 3/14/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Person: Object {

    @objc dynamic var id: String? = nil
    @objc dynamic var year: String? = nil
    @objc dynamic var avatar: String? = nil
    @objc dynamic var firstName: String? = nil
    @objc dynamic var lastName: String? = nil
    @objc dynamic var aboutMe: String? = nil
    var experience = List<Experience>()

    var imagePath: String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return "\(paths[0])/MyImage.png"
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}

class Experience: Object {
    @objc dynamic var organization: String? = nil
    @objc dynamic var responsibility: String? = nil
    @objc dynamic var position: String? = nil
    @objc dynamic var period: String? = nil
}

extension Experience: CRUDService {}
extension Person: CRUDService {}


