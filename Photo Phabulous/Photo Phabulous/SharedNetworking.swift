//
//  SharedNetworking.swift
//  Photo Phabulous
//
//  Created by Isabel  Lee on 22/02/2017.
//  Copyright © 2017 Isabel  Lee. All rights reserved.
//


import UIKit

enum NetworkError: Error {
    case CantLoadData
    case DataIsNil
    case JsonParsingError
    case CantLoadImg
}

class SharedNetworking {
    static let sharedInstance = SharedNetworking()
    private init() {}

    var imageUrl : [String]? = []
    let session = URLSession.shared
    let imageCache = NSCache<NSString, UIImage>()


    //load the json data from server
    func loadData(completion: @escaping (([String]?, Error?)->Void)){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        imageUrl = []
        
        let urlString = "http://stachesandglasses.appspot.com/user/ijlee/json/"
        
        
        guard let url = NSURL(string: urlString) else {
            imageUrl = nil
            completion(self.imageUrl, NetworkError.CantLoadData)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            return
        }
        
        let task = session.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
            
            do {
                try self.imageUrl = self.parseJson(data: data, error: error)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.saveToDoc(parsedImgUrls: self.imageUrl!)
                completion(self.imageUrl, nil)
                
            }catch{
                print("\(error)")
                self.imageUrl = nil
                completion(self.imageUrl, error)
            }
            
        })
        
        task.resume()
    }
    
    //parse Json data downloaded into an array of strings, throwing errors as needed
    func parseJson(data: Data?, error: Error?) throws -> [String]{
        var parsedData: [String] = []
        guard error == nil else {
            print("error: \(error!.localizedDescription)")
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            throw NetworkError.CantLoadData
        }
        
        guard let data = data else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            throw NetworkError.DataIsNil
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            guard let issues = json as? [String: AnyObject] else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                throw NetworkError.JsonParsingError
            }
            
            let ImgArray = issues["results"] as! Array<Dictionary<String, AnyObject>>
            for topic in ImgArray {
                let url = topic["image_url"] as! String
                parsedData.append(url)
            }
            
        } catch {
            print("error serializing JSON: \(error)")
            throw NetworkError.JsonParsingError
        }
        
        return parsedData
    }
    
    //download the photo from the imgUrl
    func downloadPhoto(imgUrl: String, completion: @escaping ((UIImage?, Error?)->Void)){
        
        let urlString = "http://stachesandglasses.appspot.com/\(imgUrl)"
        guard let url = NSURL(string: urlString) else {
            print("Cannot create NSURL")
            completion(nil, NetworkError.CantLoadImg)
            return
        }
        
        let imgData = self.imageCache.object(forKey: imgUrl as NSString)
        if imgData != nil {
            print("img downloaded from cache")
            completion(imgData, nil)
        } else {
            let task = session.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    completion(nil, NetworkError.CantLoadImg)
                    return
                }
                let image = UIImage(data: data!)
                self.imageCache.setObject(image!, forKey: imgUrl as NSString)
                print("img downloaded from url")
                completion(image, nil)
            })
            
            task.resume()
        }
    }
    
    //save the filtered Json data (which is an array of String) in Documents in order to fetch it later
    func saveToDoc(parsedImgUrls: [String]){
        let docs = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("\(docs)")
        NSKeyedArchiver.archiveRootObject(parsedImgUrls, toFile: docs.appending("/imagejson.plist"))
    }
}


