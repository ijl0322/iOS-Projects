//
//  OpenViewController.swift
//  Github Issues
//
//  Created by Isabel  Lee on 31/01/2017.
//  Copyright © 2017 Isabel  Lee. All rights reserved.
//


// - Attribution: http://stackoverflow.com/questions/24170922/creating-custom-tableview-cells-in-swift
// - Attribution: https://www.youtube.com/watch?v=5lH5fSuDVxg
// - Attribution: https://icons8.com/
// - Attribution: http://stackoverflow.com/questions/31182847/how-to-detect-tableview-cell-touched-or-clicked-in-swift
// - Attribution: http://dev.iachieved.it/iachievedit/handling-dates-with-swift-3-0/
// - Attribution: http://www.globalnerdy.com/2016/08/22/how-to-work-with-dates-and-times-in-swift-3-part-2-dateformatter/
// - Attribution: https://www.raywenderlich.com/120442/swift-json-tutorial


import UIKit


class IssueTableViewController: UITableViewController {
    
    //Mark: Variables
    var valueToPass:String!
    var issueList: [[String]] = []
    var issueInfo: [String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        
        loadData { (issues) in
            self.issueList = issues
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
            self.issueList = issues
            dump(self.issueList)
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
        let cell:MyCustomCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyCustomCell
        
        cell.titleLabel.text = issueList[indexPath.row][4]
        cell.myImg.image = UIImage(named: "open")
        cell.authorLabel.text = issueList[indexPath.row][1]
        cell.timestampLabel.text = issueList[indexPath.row][3]

        return cell
    }
    
    // passes data(an array of string with each element being [state, author, url, date, title] of a post) to IssueDetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if (segue.identifier == "issueDetailSegue") {

            let viewController = segue.destination as! IssueDetailViewController
            
            let selectedRow = self.tableView.indexPathForSelectedRow!.row
            viewController.passedData = issueList[selectedRow]
            
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
        
        let urlString = "https://api.github.com/repos/uchicago-mobi/mpcs51030-2017-winter-forum/issues?state=open"
        
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
            
            completion(self.issueList)
        })
        
        task.resume()

    }

}
