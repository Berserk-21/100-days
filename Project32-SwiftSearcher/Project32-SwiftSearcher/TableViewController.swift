//
//  TableViewController.swift
//  Project32-SwiftSearcher
//
//  Created by Berserk on 14/12/2023.
//

import UIKit
import SafariServices
import CoreSpotlight
import MobileCoreServices

class TableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var projects = [[String]]()
    private var favorites = [Int]()
    private var favoritesTutorialKey: String = "favoritesTutorial"

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        prepareTableView()
        prepareTutorials()
        prepareFavorites()
    }

    // MARK: - Custom Methods
    
    private func prepareTableView() {
        
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
    }
    
    private func prepareTutorials() {
        projects.append(["Project 1: Storm Viewer", "Constants and variables, UITableView, UIImageView, FileManager, storyboards"])
        projects.append(["Project 2: Guess the Flag", "@2x and @3x images, asset catalogs, integers, doubles, floats, operators (+= and -=), UIButton, enums, CALayer, UIColor, random numbers, actions, string interpolation, UIAlertController"])
        projects.append(["Project 3: Social Media", "UIBarButtonItem, UIActivityViewController, the Social framework, URL"])
        projects.append(["Project 4: Easy Browser", "loadView(), WKWebView, delegation, classes and structs, URLRequest, UIToolbar, UIProgressView., key-value observing"])
        projects.append(["Project 5: Word Scramble", "Closures, method return values, booleans, NSRange"])
        projects.append(["Project 6: Auto Layout", "Get to grips with Auto Layout using practical examples and code"])
        projects.append(["Project 7: Whitehouse Petitions", "JSON, Data, UITabBarController"])
        projects.append(["Project 8: 7 Swifty Words", "addTarget(), enumerated(), count, index(of:), property observers, range operators."])
    }
    
    private func prepareFavorites() {
        
        if let existingFavorites = UserDefaults.standard.object(forKey: favoritesTutorialKey) as? [Int] {
            self.favorites = existingFavorites
        }
    }
    
    private func makeAttributedString(for project: [String]) -> NSAttributedString {
        
        let titleAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.purple]
        let titleString = NSMutableAttributedString(string: project[0] + "\n", attributes: titleAttributes)
        
        let subtitleAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .subheadline)]
        let subtitleString = NSAttributedString(string: project[1], attributes: subtitleAttributes)
        
        titleString.append(subtitleString)
        
        return titleString
    }
    
    private func showTutorial(for projectIndex: Int) {
        
        if let url = URL(string: "https://www.hackingwithswift.com/read/\(projectIndex + 1)") {
            
            let configuration = SFSafariViewController.Configuration()
            configuration.entersReaderIfAvailable = true
            
            let safariController = SFSafariViewController(url: url, configuration: configuration)
            present(safariController, animated: true)
        }
    }
    
    /// Indexes an item to be accessible through Spotlight searches system.
    private func index(item: Int) {
        
        guard projects.count > item else { return }
        
        let project = projects[item]
        
        let attributeSet = CSSearchableItemAttributeSet(contentType: .text)
        attributeSet.identifier = project[0]
        attributeSet.title = attributeSet.identifier
        attributeSet.displayName = attributeSet.identifier
        attributeSet.contentDescription = project[1]
        
        let item = CSSearchableItem(uniqueIdentifier: "com.hackingwithswift_bersker21+\(item)", domainIdentifier: "com.hackingwithswift_bersker21", attributeSet: attributeSet)
        item.expirationDate = .distantFuture
        CSSearchableIndex.default().indexSearchableItems([item]) { error in
            if let err = error {
                print("There was an error indexing: \(err.localizedDescription)")
            } else {
                print("search item successfully indexed!: \(attributeSet.identifier)")
            }
        }
    }
    
    /// Removes an item indexation from Spotlight searches.
    private func deindex(item: Int) {
        
        guard projects.count > item else { return }
        
        let identifiers: [String] = ["\(item)"]
        
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: identifiers) { error in
            if let err = error {
                print("There was an error deleting searchableItem: \(item): \(err.localizedDescription)")
            } else {
                print("item \(item) successfully deleted")
            }
        }
    }

    // MARK: - UITableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let project = projects[indexPath.row]
        
        cell.textLabel?.attributedText = makeAttributedString(for: project)
        cell.editingAccessoryType = favorites.contains(indexPath.row) ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - UITableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        showTutorial(for: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return favorites.contains(indexPath.row) ? .delete : .insert
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete:
            if let index = favorites.firstIndex(of: indexPath.row) {
                favorites.remove(at: index)
            }
            
            deindex(item: indexPath.row)
        case .insert:
            favorites.append(indexPath.row)
            index(item: indexPath.row)
        default:
            break
        }
        
        UserDefaults.standard.set(favorites, forKey: favoritesTutorialKey)
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

