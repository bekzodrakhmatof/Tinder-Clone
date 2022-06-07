//
//  SettingsController.swift
//  Tinder
//
//  Created by Bekzod Rakhmatov on 03/02/2019.
//  Copyright © 2019 BekzodRakhmatov. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

protocol SettingsControllerDelegate {
    func didSaveSettings()
}

class CustomerImagePickerController: UIImagePickerController {
    
    var imageButton: UIButton?
    
}

class SettingsController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var settingDelegate: SettingsControllerDelegate?
    
    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))
    
    @objc func handleSelectPhoto(button: UIButton) {
        
        let imagePickerController = CustomerImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageButton = button
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomerImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        let fileName = UUID().uuidString
        let reference = Storage.storage().reference(withPath: "/images/\(fileName)")
        guard let uploadDate = selectedImage?.jpegData(compressionQuality: 0.75) else { return }
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading image..."
        hud.show(in: view)
        reference.putData(uploadDate, metadata: nil) { (nil, error) in
            
            if let error = error {
                
                hud.dismiss()
                print("Failed to upload to Storage: \(error)")
                return
            }
            
            reference.downloadURL(completion: { (url, error) in
                
                hud.dismiss()
                
                if let error = error {
                    
                    print("Failed to retrieve download url: \(error)")
                    return
                }
                
                if imageButton == self.image1Button {
                    
                    self.user?.imageUrl1 = url?.absoluteString
                    
                } else if imageButton == self.image2Button {
                    
                    self.user?.imageUrl2 = url?.absoluteString
                    
                } else {
                    
                    self.user?.imageUrl3 = url?.absoluteString
                }
            })
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func createButton(selector: Selector) -> UIButton {
        
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        
        fetchCurrentUser()
    }
    
    var user: User?
    
    fileprivate func fetchCurrentUser() {
        
        Firestore.firestore().fetchCurrentUser { (user, error) in
            if let error = error {
                print("Failed to fetch user:", error)
                return
            }
            self.user = user
            self.loadUserPhotos()
            self.tableView.reloadData()
        }
    }
    
    fileprivate func loadUserPhotos() {
        
        if let imageUrl = user?.imageUrl1, let url = URL(string: imageUrl) {
            
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.image1Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
        if let imageUrl = user?.imageUrl2, let url = URL(string: imageUrl) {
            
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.image2Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
        if let imageUrl = user?.imageUrl3, let url = URL(string: imageUrl) {
            
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.image3Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
    lazy var headerView: UIView = {
        
        let headerView = UIView()
        headerView.addSubview(image1Button)
        let padding: CGFloat = 16
        image1Button.anchor(top: headerView.topAnchor, leading: headerView.leadingAnchor, bottom: headerView.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: -padding, right: 0))
        image1Button.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.45).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        
        headerView.addSubview(stackView)
        stackView.anchor(top: headerView.topAnchor, leading: image1Button.trailingAnchor, bottom: headerView.bottomAnchor, trailing: headerView.trailingAnchor, padding: .init(top: padding, left: padding, bottom: -padding, right: -padding))
        return headerView
    }()
    
    class HeaderLabel: UILabel {
        
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        if section == 0 {
            
            return headerView
            
        } else {
            
            let headerLabel = HeaderLabel()
            switch section {
            case 1:
                headerLabel.text = "Name"
                break
            case 2:
                headerLabel.text = "Profession"
                break
            case 3:
                headerLabel.text = "Age"
                break
            case 4:
                headerLabel.text = "Bio"
                break
            default:
                headerLabel.text = "Seeking Age Range"
            }
            headerLabel.font = UIFont.boldSystemFont(ofSize: 14)
            return headerLabel
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            
            return 300
            
        } else {
            
            return 40
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? 0 : 1
    }
    
    static let defaultMinSeekingAge = 18
    static let defaultMaxSeekingAge = 50
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 5 {
            
            let ageRangeCell = AgeRangeCell(style: .default, reuseIdentifier: nil)
            
            ageRangeCell.minSlider.addTarget(self, action: #selector(handleMinSliderChange), for: .valueChanged)
            ageRangeCell.maxSlider.addTarget(self, action: #selector(handleMaxSliderChange), for: .valueChanged)
            
            let minAge = user?.minSeekingAge ?? SettingsController.defaultMinSeekingAge
            let maxAge = user?.maxSeekingAge ?? SettingsController.defaultMaxSeekingAge
            
            ageRangeCell.minLabel.text = "Min: \(minAge)"
            ageRangeCell.maxLabel.text = "Max: \(maxAge)"
            
            ageRangeCell.minSlider.value = Float(CGFloat(minAge))
            ageRangeCell.maxSlider.value = Float(CGFloat(maxAge))
            return ageRangeCell
        }
        
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
            break
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
            break
        case 3:
            cell.textField.placeholder = "Enter Age"
            if let age = user?.age {
                cell.textField.text = String(age)
            }
            cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
            break
        default:
            cell.textField.placeholder = "Enter Bio"
        }
        return cell
    }
    
    @objc fileprivate func handleMinSliderChange(slider: UISlider) {
        
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        
        if ageRangeCell.minSlider.value > ageRangeCell.maxSlider.value {
            
            ageRangeCell.maxSlider.value = ageRangeCell.minSlider.value
            ageRangeCell.maxLabel.text = "Max: \(Int(slider.value))"
        }
        ageRangeCell.minLabel.text = "Min: \(Int(slider.value))"
    
        self.user?.minSeekingAge = Int(slider.value)
    }
    
    @objc fileprivate func handleMaxSliderChange(slider: UISlider) {
        
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        if ageRangeCell.maxSlider.value < ageRangeCell.minSlider.value {
            
            ageRangeCell.minSlider.value = ageRangeCell.maxSlider.value
            ageRangeCell.minLabel.text = "Min: \(Int(slider.value))"
        }
        ageRangeCell.maxLabel.text = "Max: \(Int(slider.value))"
        
        self.user?.maxSeekingAge = Int(slider.value)
    }
    
    @objc fileprivate func handleNameChange(textField: UITextField) {
        
        self.user?.name = textField.text
    }
    
    @objc fileprivate func handleProfessionChange(textField: UITextField) {
        
        self.user?.profession = textField.text
    }
    
    @objc fileprivate func handleAgeChange(textField: UITextField) {
        
        self.user?.age = Int(textField.text ?? "")
    }
    
    fileprivate func setupNavigationItems() {
        
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelButton))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSaveButton)), UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogoutButton))]
    }
    
    @objc fileprivate func handleCancelButton() {
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handleSaveButton() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let documentData: [String : Any] = [
            "uid": uid,
            "fullName": user?.name ?? "",
            "imageUrl1": user?.imageUrl1 ?? "",
            "imageUrl2": user?.imageUrl2 ?? "",
            "imageUrl3": user?.imageUrl3 ?? "",
            "age": user?.age ?? -1,
            "profession": user?.profession ?? "",
            "minSeekingAge": user?.minSeekingAge ?? -1,
            "maxSeekingAge": user?.maxSeekingAge ?? -1
            ]
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving settings"
        hud.show(in: view)
        
        Firestore.firestore().collection("users").document(uid).setData(documentData) { (error) in
            
            hud.dismiss()
            
            if let error = error {
                print("Failed to save user setting: \(error)")
                return
            }
            
            self.dismiss(animated: true, completion: {
                print("Dismissal complete")
                self.settingDelegate?.didSaveSettings()
            })
        }
    }
    
    @objc fileprivate func handleLogoutButton() {
        
        try? Auth.auth().signOut()
        dismiss(animated: true)
    }
}
