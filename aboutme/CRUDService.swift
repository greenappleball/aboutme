//
//  CRUDService.swift
//  aboutme
//
//  Created by Dmitri Petrishin on 3/14/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import RealmSwift

protocol CRUDService {
    func create()
    func update(with dictionary: [String: Any?])
    func delete()
}

// MARK: CRUDService
extension CRUDService where Self: Object {
    func create() {
        RealmManager.shared.create(self)
    }

    func update(with dictionary: [String: Any?]) {
        RealmManager.shared.update(self, with: dictionary)
    }

    func delete() {
        RealmManager.shared.delete(self)
    }

}
