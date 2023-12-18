//
//  ViewController.swift
//  Project10_collectionview
//
//  Created by Berserk on 04/10/2023.
//

import UIKit

final class MainCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    private var people = [Person]()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupLayout()
        loadPeople()
    }
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPicture))
    }
    
    // MARK: - Helper Methods
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func showPicker(sourceType: UIImagePickerController.SourceType) {
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = sourceType
        
        present(picker, animated: true)
    }
    
    private func loadPeople() {
        
        let defaults = UserDefaults.standard
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [Person] {
                people = decodedPeople
                collectionView.reloadData()
            }
        }
    }
    
    private func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            
            defaults.set(savedData, forKey: "people")
        }
    }
    
    private func RenameOrRemove(for person: Person, selectedCell: UICollectionViewCell) {
        
        let firstAC = UIAlertController(title: "Rename or delete ?", message: nil, preferredStyle: .actionSheet)
        
        firstAC.addAction(UIAlertAction(title: "Rename", style: .default, handler: { [weak self] _ in
            
            let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: UIAlertController.Style.alert)
            
            ac.addTextField()
            
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak ac] _ in
                guard let newName = ac?.textFields?[0].text else {
                    return
                }
                
                person.name = newName
                self?.collectionView.reloadData()
                self?.save()
            }))
            
            ac.popoverPresentationController?.sourceView = selectedCell
            self?.present(ac, animated: true)
        }))
        
        firstAC.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            
            self?.people.removeAll(where: { $0.image == person.image })
            self?.collectionView.reloadData()
            self?.save()
        }))
        
        firstAC.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        firstAC.popoverPresentationController?.sourceView = selectedCell
        
        present(firstAC, animated: true)
    }
    
    // MARK: - Actions

    @objc private func addPicture() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let ac = UIAlertController(title: "Select a source", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
                self?.showPicker(sourceType: .camera)
            }))
            ac.addAction(UIAlertAction(title: "Photos library", style: .default, handler: { [weak self] _ in
                self?.showPicker(sourceType: .photoLibrary)
            }))
            
            ac.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel))
            ac.popoverPresentationController?.sourceItem = navigationItem.leftBarButtonItem
            
            present(ac, animated: true)
        } else {
            self.showPicker(sourceType: .photoLibrary)
        }
    }
    
    // MARK: - UIImagePickerController Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageID = UUID().uuidString
        let imagePath = getDocumentsDirectory().appending(path: imageID)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            
            do {
                try jpegData.write(to: imagePath)
                
                let person = Person(name: "Unknown", image: imageID)
                self.people.append(person)
                self.collectionView.reloadData()
                self.save()
            } catch let error {
                print("There was an error trying to save image on disk: \(error.localizedDescription)")
            }
        }
        
        dismiss(animated: true)
    }
    
    // MARK: - UICollectionView DataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCollectionViewCell.identifier, for: indexPath) as? PersonCollectionViewCell else {
            fatalError("Unable to dequeue a PersonCollectionViewCell")
        }
        
        let person = people[indexPath.row]
        
        cell.nameLabel.text = person.name
        
        let imagePath = getDocumentsDirectory().appending(path: person.image)
        cell.imageView.image = UIImage(contentsOfFile: imagePath.path())
        cell.imageView.layer.borderColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2.0
        cell.imageView.layer.cornerRadius = 3.0
        cell.imageView.layer.masksToBounds = true
        
        cell.layer.cornerRadius = 7.0
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let person = people[indexPath.item]
        
        guard let selectedCell = collectionView.cellForItem(at: indexPath) else {
            print("Couldn't get the selected cell")
            return
        }
        
        RenameOrRemove(for: person, selectedCell: selectedCell)
    }
}

