//
//  PersonCell.swift
//  aboutme
//
//  Created by Dmitri Petrishin on 3/14/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var avatarImageView: UIImageView!

    weak var person: Person?
}

extension PersonCell: Fillable {
    func fill(by person: Person) -> Void {
        self.person = person
        firstNameField.text = person.firstName
        lastNameField.text = person.lastName
        yearField.text = person.year

        do {
            let url = URL(fileURLWithPath: person.avatar)
            let data = try Data(contentsOf: url)
            let image = UIImage(data: data)
            avatarImageView.image = image
        } catch {
            debugPrint(error)
        }
    }
}


extension PersonCell: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            let proposed = (text as NSString).replacingCharacters(in: range, with: string)
            var key: String = ""
            if textField == firstNameField {
                key = #keyPath(Person.firstName)
            } else if textField == lastNameField {
                key = #keyPath(Person.lastName)
            } else if textField == yearField {
                key = #keyPath(Person.year)
            }
            guard key.count > 0 else { fatalError("Expected key. Reason: unsupported field")}
            person?.update(with: [key : proposed])
        }
        return true
    }
}
