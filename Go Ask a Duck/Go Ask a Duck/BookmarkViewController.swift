//
//  BookmarkViewController.swift
//  Go Ask a Duck
//
//  Created by Isabel  Lee on 15/02/2017.
//  Copyright © 2017 Isabel  Lee. All rights reserved.
//


import UIKit

class BookmarkViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    let defaults = UserDefaults.standard
    var favorites: [String] = []
    weak var delegate: DetailBookmarkDelegate?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if let fav = defaults.object(forKey: "bookmarks") {
            favorites = fav as! [String]
        }
    }
}

extension BookmarkViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "CellB"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        
        cell.textLabel?.text = favorites[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("selected")
        let url = favorites[indexPath.row]
        delegate?.bookmarkPassedURL(url: url)
        self.performSegue(withIdentifier: "backToDetail", sender: Any?.self)
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            UserDefaults.standard.set(favorites, forKey: "bookmarks")

        }
    }
}
