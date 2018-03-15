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

    fileprivate var datePicker: UIDatePicker?
    fileprivate var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: frame.width, height: 216))
        datePicker?.backgroundColor = .white
        datePicker?.datePickerMode = UIDatePickerMode.date

        let doneToButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneHandler(_:)))
        let spaceToButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelToButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelHandler(_:)))
        yearField.makeToolBar(items: [cancelToButton, spaceToButton, doneToButton])

        yearField.inputView = datePicker
    }

    // MARK:
    @objc func doneHandler(_ sender: UIBarButtonItem) -> Void {
        guard let date = datePicker?.date else { return }
        let text = formatter.string(from: date)
        yearField.text = text
        person?.update(with: [#keyPath(Person.year) : text])
        yearField.resignFirstResponder()
    }

    @objc func cancelHandler(_ sender: UIDatePicker) -> Void {
        yearField.resignFirstResponder()
    }
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == yearField {
            datePicker?.date = formatter.date(from: person?.year ?? "") ?? Date()
        }
    }

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
