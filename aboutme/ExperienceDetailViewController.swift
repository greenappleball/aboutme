//
//  ExperienceDetailViewController.swift
//  aboutme
//
//  Created by Dmitri Petrishin on 3/15/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

class ExperienceDetailViewController: UIViewController {
    @IBOutlet weak var organizationField: UITextField!
    @IBOutlet weak var positionField: UITextField!
    @IBOutlet weak var responsibilityField: UITextField!
    @IBOutlet weak var periodField: UITextField!
    @IBOutlet weak var toField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    
    var viewModel: ExperienceDetailViewModel?

    fileprivate var datePicker: UIDatePicker?
    fileprivate var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }

    // MARK:
    @IBAction func saveHandler(_ sender: UIButton) {
        viewModel?.save()
        navigationController?.popViewController(animated: true)
    }

    @IBAction func deleteHandler(_ sender: UIButton) {
        viewModel?.delete()
        navigationController?.popViewController(animated: true)
    }
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()

        organizationField.text = viewModel?.experience?.organization
        positionField.text = viewModel?.experience?.position
        responsibilityField.text = viewModel?.experience?.responsibility
        periodField.text = viewModel?.experience?.periodFrom
        toField.text = viewModel?.experience?.periodTo
        deleteButton.isEnabled = viewModel?.experience != nil

        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 216))
        datePicker?.backgroundColor = .white
        datePicker?.minimumDate = Date(timeIntervalSince1970: 0)
        datePicker?.datePickerMode = UIDatePickerMode.date

        datePicker?.date = Date()

        // Adding ToolBar
        let doneFromButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneFromHandler(_:)))
        let spaceFromButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelFromButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelHandler(_:)))
        periodField.makeToolBar(items: [cancelFromButton, spaceFromButton, doneFromButton])

        let doneToButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneToHandler(_:)))
        let spaceToButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelToButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelHandler(_:)))
        toField.makeToolBar(items: [cancelToButton, spaceToButton, doneToButton])

        periodField.inputView = datePicker
        toField.inputView = datePicker
    }

    // MARK:
    @objc func doneFromHandler(_ sender: UIBarButtonItem) -> Void {
        guard let date = datePicker?.date else { return }
        let text = formatter.string(from: date)
        periodField.text = text
        viewModel?.periodFrom = text
        view.endEditing(true)
    }

    @objc func doneToHandler(_ sender: UIBarButtonItem) -> Void {
        guard let date = datePicker?.date else { return }
        let text = formatter.string(from: date)
        toField.text = text
        viewModel?.periodTo = text
        view.endEditing(true)
    }

    @objc func cancelHandler(_ sender: UIDatePicker) -> Void {
        view.endEditing(true)
    }
}

extension ExperienceDetailViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == periodField {
            var date = Date()
            if let text = viewModel?.experience?.periodFrom {
                date = formatter.date(from: text) ?? Date()
            }
            datePicker?.date = date
        } else if textField == toField {
            var date = Date()
            if let text = viewModel?.experience?.periodTo {
                date = formatter.date(from: text) ?? Date()
            }
            datePicker?.date = date
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if let text = textField.text {
            let proposed = (text as NSString).replacingCharacters(in: range, with: string)
            if textField == organizationField {
                viewModel?.organization = proposed
            } else if textField == positionField {
                viewModel?.position = proposed
            } else if textField == responsibilityField {
                viewModel?.responsibility = proposed
            }
        }
        return true
    }
}
