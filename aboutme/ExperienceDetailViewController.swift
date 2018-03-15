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
    @IBOutlet weak var deleteButton: UIButton!
    
    var viewModel: ExperienceDetailViewModel?

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
        periodField.text = viewModel?.experience?.period
        deleteButton.isEnabled = viewModel?.experience != nil
    }
}

extension ExperienceDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if let text = textField.text {
            let proposed = (text as NSString).replacingCharacters(in: range, with: string)
            if textField == organizationField {
                viewModel?.organization = proposed
            } else if textField == positionField {
                viewModel?.position = proposed
            } else if textField == responsibilityField {
                viewModel?.responsibility = proposed
            } else if textField == periodField {
                viewModel?.period = proposed
            }
        }
        return true
    }
}
