//
//  CircleViewController.swift
//  Github Issues
//
//  Created by Isabel  Lee on 01/02/2017.
//  Copyright © 2017 Isabel  Lee. All rights reserved.
//




import UIKit

class CircleViewController: UIViewController {
    
    //Mark: Properties
    @IBOutlet weak var openIssue: UILabel!
    
    @IBOutlet weak var closeIssue: UILabel!
    
    //Mark: Variables
    var issueList: [String] = []
    var NumClosedIssues = 0
    var NumOpenIssues = 0
    
    //calculate the number of open and closed issues
    override func viewDidLoad() {
        
        loadData { (issues) in
            self.issueList = issues
            DispatchQueue.main.async {
                for state in self.issueList {
                    if state == "open"{
                        self.NumOpenIssues += 1
                    } else {
                        self.NumClosedIssues += 1
                    }
                }
                self.openIssue.text = "\(self.NumOpenIssues) Open"
                self.closeIssue.text = "\(self.NumClosedIssues) Closed"

            }
            
        }
    }
    
    //draw circles using CGRect
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let circleGreen = UIView(frame: CGRect(x: 100.0, y: 300.0, width: 260.0, height: 260.0))
        circleGreen.center = view.center
        circleGreen.layer.cornerRadius = 130.0
        circleGreen.layer.borderColor = UIColor.green.cgColor
        circleGreen.layer.borderWidth = 4.0
        circleGreen.layer.backgroundColor = UIColor.clear.cgColor
        
        let circleRed = UIView(frame: CGRect(x: 100.0, y: 300.0, width: 230.0, height: 230.0))
        circleRed.center = view.center
        circleRed.layer.cornerRadius = 115.0
        circleRed.layer.borderColor = UIColor.red.cgColor
        circleRed.layer.borderWidth = 4.0
        circleRed.layer.backgroundColor = UIColor.clear.cgColor
        
        view.addSubview(circleGreen)
        view.addSubview(circleRed)

        
    }

    //load data from github API, only storing the status of each post
    func loadData(completion: @escaping (([String])->Void) ){
        
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
                //print("\(json)")
                
                guard let issues = json as? [[String: AnyObject]] else {
                    fatalError("We couldn't cast the JSON to an array of dictionaries")
                }
                
                //print ("\(issues)")
                for issue in issues {
                    for (key, value) in issue {
                        //print ("\(key) ---------- \(value)")
                        if key == "state" {
                            if let state = value as? String {
                                self.issueList.append(state)
                            }
                        }
                    }
                }
                
                
            } catch {
                print("error serializing JSON: \(error)")
            }
            
            completion(self.issueList)
            //dump(self.issueList)
            
        })
        
        // Tasks start off in suspended state, we need to kick it off
        task.resume()
        
        //dump(self.issueList)
        
    }
    
    
}

