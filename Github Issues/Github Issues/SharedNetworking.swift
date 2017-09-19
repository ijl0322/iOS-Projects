//
//  SharedNetworking.swift
//  Github Issues
//
//  Created by Isabel  Lee on 19/09/2017.
//  Copyright © 2017 Isabel  Lee. All rights reserved.
//

import Foundation

class SharedNetworking {
    static let shared = SharedNetworking()
    var issueList: [[String]] = []
    var issueInfo: [String] = []
    private init() {}
    
    func loadData(completion: @escaping ([[String]])-> Void){
        let urlString = "https://api.github.com/repos/uchicago-mobi/mpcs51030-2017-winter-forum/issues?state=open"
        guard let url = URL(string: urlString) else {
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
            
            guard error == nil else {return}
            guard data != nil else {return}
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                guard let issues = json as? [[String:AnyObject]] else {return}
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
                print("JSON error")
            }
            
            completion(self.issueList)
        })
        
        task.resume()
    }
    
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
}
