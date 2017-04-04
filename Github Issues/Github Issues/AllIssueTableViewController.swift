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
        
        loadData { (issues) in
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
        
        loadData { (issues) in
            dump(issues)
            self.issueList = issues
            DispatchQueue.main.async {
                //self.issueList.append(["test","test","test","test","test"])
                self.tableView.reloadData()
                
            }
        }
        refreshControl.endRefreshing()
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
    
    
    // format data to show in date field
    func dateFormat(_ dateVal: String) -> String{
        let myDateFormatter = DateFormatter()
        myDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        myDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        myDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = myDateFormatter.date(from:dateVal)
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        let new = formatter.string(from: date!)
        return new
    }
    
    
    // load data from the github API by parsing JSON
    func loadData(completion: @escaping (([[String]])->Void) ){
        

        
        let urlString = "https://api.github.com/repos/uchicago-mobi/mpcs51030-2017-winter-forum/issues?state=all"
        
        guard let url = NSURL(string: urlString) else {
            fatalError("Unable to create NSURL from string")
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
            
            guard error == nil else {
                print("error: \(error!.localizedDescription)")
                fatalError("Error: \(error!.localizedDescription)")
            }
            
            guard let data = data else {
                fatalError("Data is nil")
            }
            
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                guard let issues = json as? [[String: AnyObject]] else {
                    fatalError("We couldn't cast the JSON to an array of dictionaries")
                }
                
                self.issueList = []
                for issue in issues {
                    self.issueInfo = []
                    for (key, value) in issue {
                        if key == "user" {
                            if let id = value["login"] as? String {
                                self.issueInfo.append(id)
                                
                            }
                        }
                        if key == "title" {
                            if let title = value as? String {
                                self.issueInfo.append(title)
                                
                            }
                        }
                        if key == "created_at" {
                            if let timestamp = value as? String {
                                self.issueInfo.append(self.dateFormat(timestamp))
                                
                            }
                        }
                        if key == "html_url" {
                            if let html = value as? String {
                                self.issueInfo.append(html)
                                
                            }
                        }
                        if key == "state" {
                            if let state = value as? String {
                                self.issueInfo.append(state)
                            }
                            
                        }
                        
                    }
                    self.issueList.append(self.issueInfo)
                }
                
            } catch {
                print("error serializing JSON: \(error)")
            }
            dump(self.issueList)
            completion(self.issueList)
        
            
        })
        
        task.resume()
        
    }
    
}
