//
//  TableViewController.swift
//  Project32-SwiftSearcher
//
//  Created by Berserk on 14/12/2023.
//

import UIKit
import SafariServices

class TableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var projects = [[String]]()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        prepareData()
    }

    // MARK: - Custom Methods
    
    private func prepareData() {
        projects.append(["Project 1: Storm Viewer", "Constants and variables, UITableView, UIImageView, FileManager, storyboards"])
        projects.append(["Project 2: Guess the Flag", "@2x and @3x images, asset catalogs, integers, doubles, floats, operators (+= and -=), UIButton, enums, CALayer, UIColor, random numbers, actions, string interpolation, UIAlertController"])
        projects.append(["Project 3: Social Media", "UIBarButtonItem, UIActivityViewController, the Social framework, URL"])
        projects.append(["Project 4: Easy Browser", "loadView(), WKWebView, delegation, classes and structs, URLRequest, UIToolbar, UIProgressView., key-value observing"])
        projects.append(["Project 5: Word Scramble", "Closures, method return values, booleans, NSRange"])
        projects.append(["Project 6: Auto Layout", "Get to grips with Auto Layout using practical examples and code"])
        projects.append(["Project 7: Whitehouse Petitions", "JSON, Data, UITabBarController"])
        projects.append(["Project 8: 7 Swifty Words", "addTarget(), enumerated(), count, index(of:), property observers, range operators."])
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

    // MARK: - UITableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let project = projects[indexPath.row]
        
        cell.textLabel?.attributedText = makeAttributedString(for: project)
        
        return cell
    }
    
    // MARK: - UITableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        showTutorial(for: indexPath.row)
    }
}

