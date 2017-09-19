//
//  AllIssueTableViewController.swift
//  Github Issues
//
//  Created by Isabel  Lee on 01/02/2017.
//  Copyright © 2017 Isabel  Lee. All rights reserved.
//

import UIKit


class AllIssueTableViewController: UITableViewController {
    
    //Mark: Variables
    var valueToPass:String!
    var issueList: [[String]] = []
    var issueInfo: [String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        
        SharedNetworking.shared.loadData { (issues) in
            self.issueList = issues
            print("issue list")
            dump(self.issueList)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
    }
    
    // handleRefresh reloads data and updates the table
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        SharedNetworking.shared.loadData { (issues) in
            dump(issues)
            self.issueList = issues
            DispatchQueue.main.async {
                self.tableView.reloadData()
                refreshControl.endRefreshing()
            }
        }
    }
    
    // set the number of columns in the table to the number of issues
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issueList.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // set up each table using the data we go from the github API
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MyCustomCell2 = self.tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! MyCustomCell2
        
        cell.titleLabelAll.text = issueList[indexPath.row][4]
        cell.myImgAll.image = UIImage(named: "open")
        cell.authorLabelAll.text = issueList[indexPath.row][1]
        cell.timestampLabelAll.text = issueList[indexPath.row][3]
        
        if issueList[indexPath.row][0] == "open" {
            cell.myImgAll.image = UIImage(named: "open")
        }
        else {
            cell.myImgAll.image = UIImage(named: "closed")
        }
        return cell
    }
    
    // passes data(an array of string with each element being [state, author, url, date, title] of a post) to IssueDetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if (segue.identifier == "allIssueSegue") {
           
            let viewController = segue.destination as! AllIssueDetailViewController
            
            let selectedRow = self.tableView.indexPathForSelectedRow!.row
            viewController.passedData1 = issueList[selectedRow]
            
        }
    }
}
