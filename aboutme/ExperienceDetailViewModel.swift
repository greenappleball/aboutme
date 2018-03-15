//
//  ExperienceDetailViewModel.swift
//  aboutme
//
//  Created by Dmitri Petrishin on 3/15/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

class ExperienceDetailViewModel: NSObject {

    weak var holder: Person!
    var experience: Experience?

    var organization: String?
    var position: String?
    var responsibility: String?
    var period: String?

    // MARK:
    init(model: Experience?, person: Person) {
        experience = model
        holder = person
    }

    // MARK:
    func delete() -> Void {
        if let model = experience {
            model.delete()
        }
    }
    func save() -> Void {
        var data: [String: Any?] = [:]
        if let value = organization {
            data[#keyPath(Experience.organization)] = value
        }
        if let value = position {
            data[#keyPath(Experience.position)] = value
        }
        if let value = responsibility {
            data[#keyPath(Experience.responsibility)] = value
        }
        if let value = period {
            data[#keyPath(Experience.period)] = value
        }

        // perform data
        if let model = experience {
            update(model, with: data)
        } else {
            createWith(data)
        }
    }

    // MARK:
    func update(_ model: Experience, with data: [String: Any?]) -> Void {
        if data.count > 0 {
            model.update(with: data)
        }
    }

    func createWith(_ data: [String: Any?]) -> Void {
        try! RealmManager.shared.realm.write {
            let model = Experience()
            model.organization = data[#keyPath(Experience.organization)] as? String
            model.position = data[#keyPath(Experience.position)] as? String
            model.responsibility = data[#keyPath(Experience.responsibility)] as? String
            model.period = data[#keyPath(Experience.period)] as? String
            holder.experience.append(model)
        }
    }
}
