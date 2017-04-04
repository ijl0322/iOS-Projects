//
//  DetailViewController.swift
//  Go Ask a Duck
//
//  Created by Isabel  Lee on 14/02/2017.
//  Copyright © 2017 Isabel  Lee. All rights reserved.
//

// - Attribution: http://stackoverflow.com/questions/31842016/show-activity-indicator-while-website-is-loading



import UIKit

class DetailViewController: UIViewController, UIWebViewDelegate{
    
    //Mark: Variables
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var stary: UIImageView!
    var urlString = "https://duckduckgo.com/"
    var url = URL(string: "https://duckduckgo.com/")
    var bookmarkList: [String] = []

    @IBOutlet weak var activitySubView: UIView!
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var webView: UIWebView!

    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    
    //Mark: Properties
    @IBAction func favoriteButton(_ sender: UIButton) {
        bookmarkList.append(self.urlString)
        defaults.set(bookmarkList, forKey: "bookmarks")
        let readString = defaults.object(forKey: "bookmarks")
        stary.alpha = 1
        dump(readString)
    }
    
    
    func configureView() {
        // Update the user interface for the detail item.
        
        if let favorites = defaults.object(forKey: "bookmarks")
        {
            bookmarkList = favorites as! [String]
        } else {
            bookmarkList = []
        }
        
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail[0]
                url = URL(string: detail[1])
                urlString = detail[1]
                webView.loadRequest(URLRequest(url: url!))
                defaults.set(urlString, forKey: "previousPage")
                
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //check if user has lauched this app before and had view webpages. 
        //if so, load that link in the webview
        
        if let previous = defaults.object(forKey: "previousPage")
        {
            urlString = previous as! String
            url = URL(string: previous as! String)
        }
        
        
        //checks if user has set favorites, and load them into the bookmark list
        if let favorites = defaults.object(forKey: "bookmarks")
        {
            bookmarkList = favorites as! [String]
        } else {
            bookmarkList = []
        }
        
        if bookmarkList.contains(urlString){
            stary.alpha = 1
        } else {
            stary.alpha = 0
        }
        

        webView.delegate = self
        webView.loadRequest(URLRequest(url: url!))
        
        self.configureView()

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPop" {
            let dvc = segue.destination as! BookmarkViewController
            dvc.delegate = self
        }
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        activitySubView.alpha = 1
        activity.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activity.stopAnimating()
        activitySubView.alpha = 0
        if bookmarkList.contains(urlString){
            stary.alpha = 1
        } else {
            stary.alpha = 0
        }
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
   
        // -999 is an error code that returns continuously when the web load is in progress
        // where this error is returned, there is no noticable error that will bother the user
        // so it's ignored
        if (error as NSError).code == -999 {
            return
        }
        
        // pops up an UIAlertController that lets the user know that webload has failed.
        let message = "Opps..Something bad happend"
        let alert = UIAlertController(title: "Error loading View",
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        print("\(error.localizedDescription)")
        
    }
    
    var detailItem: [String]? {
        didSet {
            self.configureView()
        }
    }
    
    //allow Bookmark view controller to unwind here
    @IBAction func unwindToRVC(sender: UIStoryboardSegue) {
        print("Back at RVC")
        if let favorites = defaults.object(forKey: "bookmarks")
        {
            bookmarkList = favorites as! [String]
            //dump(bookmarkList)
        } else {
            bookmarkList = []
        }
    }

}


//confronts to the detailBookmarkDelegate protocol
extension DetailViewController: DetailBookmarkDelegate {
    func bookmarkPassedURL(url: String) {
        print("\(url)")

        self.urlString = url
        self.url = URL(string: url)
        
        webView.loadRequest(URLRequest(url: self.url!))
        defaults.set(urlString, forKey: "previousPage")

        if bookmarkList.contains(urlString){
            stary.alpha = 1
        } else {
            stary.alpha = 0
        }
    }
}
