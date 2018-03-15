//
//  RealmManager.swift
//  aboutme
//
//  Created by Dmitri Petrishin on 3/14/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    static let shared = RealmManager()

    private init() {}

    var realm: Realm {
        get {
            do {
                let realm = try Realm()
                return realm
            } catch {
                print("**REALM** instance ERROR:\(error.localizedDescription)!**")
            }
            return self.realm
        }
    }

    // MARK: CRUD
    func create<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object, update: object.classForCoder.primaryKey() != nil)
            }
        } catch {
            print("**REALM** create ERROR:", error)
        }
    }

    func read<T: Object>(_ object: T.Type) -> Results<T> {
        return self.realm.objects(object)
    }

    func read<T: Object>(_ object: T.Type, forPrimaryKey: String) -> T? {
        return realm.object(ofType: object, forPrimaryKey: forPrimaryKey)
    }

    func update<T: Object>(_ object: T, with dictionary: [String: Any?]) {
        do {
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            print("**REALM** Update ERROR:", error)
        }
    }

    func delete<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print("**REALM** delete ERROR:", error)
        }
    }

    // MARK: sequence helpers
    class func createObjects<S: Sequence>(_ objects: S) where S.Iterator.Element: Object {
        do {
            try shared.realm.write {
                shared.realm.add(objects)
            }
        } catch {
            print("**REALM** create objects ERROR:", error)
        }
    }

    class func readObjects<T: Object>(_ object: T.Type) -> [T] {
        return shared.read(object).map { $0 }
    }

    class func deleteObjects<T: Object>(_ object: T.Type) {
        do {
            try shared.realm.write {
                shared.realm.delete(shared.read(object))
            }
        } catch {
            print("**REALM** objects delete ERROR:", error)
        }
    }
}
