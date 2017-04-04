//
//  SharedNetworking.swift
//  Go Ask a Duck
//
//  Created by Isabel  Lee on 16/02/2017.
//  Copyright © 2017 Isabel  Lee. All rights reserved.
//

import Foundation
import UIKit

class SharedNetworking {
    static let sharedInstance = SharedNetworking()
    private init() {}
    
    var topicInfo : [String] = []
    var topicList:[[String]]? = []
    
    
    func loadData(keyword: String, completion: @escaping (([[String]]?)->Void)){
        
        //let urlString = "https://api.duckduckgo.com/?q=tesla&format=json&pretty=1"
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        topicInfo = []
        topicList = []
        
        let trimmedKey = keyword.components(separatedBy: " ")
        if trimmedKey == [] {
            topicList = nil
            completion(self.topicList)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            return
        }
        let finalKeyword = trimmedKey.joined(separator: "+")
        
        
        let urlString = "https://api.duckduckgo.com/?q=\(finalKeyword)&format=json&pretty=1"
        //print("Duck Duck Go\(urlString)")
        
        guard let url = NSURL(string: urlString) else {
            //fatalError("Unable to create NSURL from string")
            //self.errorAlert()
            topicList = nil
            completion(self.topicList)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            print("nsUrl =======\n\n\n\n")
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
            
            guard error == nil else {
                print("error: \(error!.localizedDescription)")
                //self.errorAlert()
                self.topicList = nil
                completion(self.topicList)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                print("task =======\n\n\n\n")
                return
                //fatalError("Error: \(error!.localizedDescription)")
            }
            
            guard let data = data else {
                //fatalError("Data is nil")
                //self.errorAlert()
                self.topicList = nil
                completion(self.topicList)
                print("data =======\n\n\n\n")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                return
                
            }
            
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                //print("\(json)")
                guard let issues = json as? [String: AnyObject] else {
                    //fatalError("We couldn't cast the JSON to a dictionaries")
                    //self.errorAlert()
                    self.topicList = nil
                    completion(self.topicList)
                    print("json =======\n\n\n\n")
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    return
                    
                }
                let RelatedTopics = issues["RelatedTopics"] as! Array<Dictionary<String, AnyObject>>
                for topic in RelatedTopics {
                    self.topicInfo = []
                    if let text = topic["Text"] {
                        self.topicInfo.append(text as! String)
                        self.topicInfo.append(topic["FirstURL"]! as! String)
                        
                    }
                    if self.topicInfo != [] {
                        self.topicList!.append(self.topicInfo)
                    }
                    
                }
                
                
            } catch {
                print("error serializing JSON: \(error)")
            }
            //dump(self.topicList)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            completion(self.topicList)
        })
        
        task.resume()
        
    }
    
}
