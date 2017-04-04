//
//  AllIssueDetailViewController.swift
//  Github Issues
//
//  Created by Isabel  Lee on 02/02/2017.
//  Copyright © 2017 Isabel  Lee. All rights reserved.
//


import UIKit

class AllIssueDetailViewController: UIViewController {

    //Mark: Variables
    var passedData1: [String]?
    
    //Mark: Properties
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    
    //Mark: Actions
    @IBAction func safariButton(_ sender: Any) {
        UIApplication.shared.open(URL(string: (passedData1?[2])!)!, options: [:], completionHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Set up titleLabel so that it becomes a multiline label when content is too long
        self.titleLabel.text = passedData1?[4]
        self.titleLabel.lineBreakMode = .byWordWrapping
        self.titleLabel.numberOfLines = 0
        
        self.authorLabel.text = passedData1?[1]
        self.dateLabel.text = passedData1?[3]
        self.statusLabel.text = passedData1?[0]
    }
    
}
