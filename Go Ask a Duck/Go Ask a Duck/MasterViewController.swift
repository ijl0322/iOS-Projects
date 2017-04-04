//
//  MasterViewController.swift
//  Go Ask a Duck
//
//  Created by Isabel  Lee on 14/02/2017.
//  Copyright © 2017 Isabel  Lee. All rights reserved.
//

// - Attribution: https://www.raywenderlich.com/129059/self-sizing-table-view-cells
// - Attribution: https://www.youtube.com/watch?v=7iT9fueKCJM
// - Attribution: http://stackoverflow.com/questions/13843183/is-it-possible-to-remove-the-edit-and-buttons-on-an-ios-master-detail-view
// - Attribution: https://www.youtube.com/watch?v=Aegohk-3ffo&t=339s

// - Attribution: http://stackoverflow.com/questions/25678373/swift-split-a-string-into-an-array
// - Attribution: http://stackoverflow.com/questions/28570973/how-should-i-remove-all-the-spaces-from-a-string-swift
// finished

import UIKit

class MasterViewController: UITableViewController, UISearchBarDelegate {
    
    //MARK: - Variables
    let defaults = UserDefaults.standard
    var topicList: [[String]] = []
    var topicInfo: [String] = []
    var keyword = "apple"
    var detailViewController: DetailViewController? = nil
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("view did load")
        
        if let searchTerm = defaults.object(forKey: "search") {
            self.keyword = searchTerm as! String
        }
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        SharedNetworking.sharedInstance.loadData(keyword: keyword) { (issues) in
            
            //issues will be nil if the shared networking failed. in that case, notify user

            //dump(self.topicList)
            DispatchQueue.main.async {
                guard let issues = issues else{
                    self.errorAlert()
                    return
                }
                self.topicList = issues
                
                dump(self.topicList)
                self.tableView.reloadData()
            }
        }
    }

    //handles search. The keyword gets passed into the sharedNeworking function loadData, 
    //and sets self.topicList as the search results.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let keyword = searchBar.text {
            self.keyword = keyword
            defaults.set(keyword, forKey: "search")
            self.topicList = []
            SharedNetworking.sharedInstance.loadData(keyword: keyword) { (issues) in

                //dump(self.topicList)
                DispatchQueue.main.async {
                    guard let issues = issues else{
                        self.errorAlert()
                        return
                    }
                    self.topicList = issues
                    
                    dump(self.topicList)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = topicList[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topicList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell

        //let object = topicList[indexPath.row]
        cell.urlLabel!.text = topicList[indexPath.row][1]
        cell.contentLabel!.text = topicList[indexPath.row][0]
        return cell
    }


    //lets user that an error occured. (webpage cant be loaded...)
    func errorAlert() {
        let message = "Opps..Something bad happend"
        let alert = UIAlertController(title: "Error loading View",
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

