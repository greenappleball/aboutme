//
//  GeneralTableViewController.swift
//  aboutme
//
//  Created by Dmitri Petrishin on 3/14/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit
import RealmSwift

class GeneralTableViewController: UITableViewController {

    fileprivate let viewModel = GeneralViewModel()

    fileprivate let imagePicker = UIImagePickerController()

    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "About Me"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ExperienceDetailViewController {
            guard let model = sender as? ExperienceDetailViewModel else {
                assertionFailure("Expected ExperienceDetailViewModel")
                return
            }
            vc.viewModel = model
        }
    }

    @IBAction func tapHandler(_ sender: UITapGestureRecognizer) {
        performImagePick()
    }
}

extension GeneralTableViewController {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewAutomaticDimension }
        if section == .experience { return 160 }
        return UITableViewAutomaticDimension
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: section.identifier, for: indexPath)

        if let fillable = cell as? AboutCell {
            fillable.fill(by: viewModel.person)
        } else if let fillable = cell as? PersonCell {
            fillable.fill(by: viewModel.person)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ExperienceCell else { return }
        cell.collectionView.dataSource = self
        cell.collectionView.delegate = self
        cell.collectionView.reloadData()
    }
}

extension GeneralTableViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.experience.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let type = indexPath.row == viewModel.experience.count ? CardType.add : CardType.card
        return type.size
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = indexPath.row == viewModel.experience.count ? CardType.add.identifier : CardType.card.identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        if let cell = cell as? CardCell {
            cell.fill(by: viewModel.experience[indexPath.row])
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var model: Experience?
        if indexPath.row < self.viewModel.experience.count {
            model = self.viewModel.experience[indexPath.row]
        }
        let viewModel = ExperienceDetailViewModel(model: model, person: self.viewModel.person)
        performSegue(withIdentifier: "segueEditExperience", sender: viewModel)
    }

}

extension GeneralTableViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.person.update(with: [#keyPath(Person.aboutMe): textView.text])
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)
    }
}

extension GeneralTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func performImagePick() -> Void {
        imagePicker.delegate = self

        let alert = UIAlertController(title: "Your Photo", message: nil, preferredStyle: .actionSheet)

        let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancel)

        let take = UIAlertAction(title: "Take Photo", style: .default, handler: { action -> Void in
            self.presentPicker(sourceType: .camera)
        })
        alert.addAction(take)

        let choose = UIAlertAction(title: "Choose From Library", style: .default, handler: { action -> Void in
            self.presentPicker(sourceType: .photoLibrary)
        })
        alert.addAction(choose)

        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        alert.popoverPresentationController?.sourceView = cell
        alert.popoverPresentationController?.sourceRect = (cell?.frame)!

        present(alert, animated: true, completion: nil)
    }

    func presentPicker(sourceType: UIImagePickerControllerSourceType) -> Void {
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        do {
            try UIImagePNGRepresentation(image)?.write(to: URL(fileURLWithPath: viewModel.person.avatar))
        } catch {
            debugPrint(error)
        }
    }
    
}

extension GeneralTableViewController {
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
