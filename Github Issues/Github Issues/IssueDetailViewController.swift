//
//  IssueDetailViewController.swift
//  Github Issues
//
//  Created by Isabel  Lee on 01/02/2017.
//  Copyright © 2017 Isabel  Lee. All rights reserved.
//


// - Attribution: https://spin.atomicobject.com/2014/10/25/ios-unwind-segues/ 
// - Attribution: http://stackoverflow.com/questions/28315133/swift-pass-uitableviewcell-label-to-new-viewcontroller?noredirect=1#comment44980102_28315133
// - Attribution: http://stackoverflow.com/questions/25368245/passing-values-between-viewcontrollers-based-on-list-selection-in-swift
// - Attribution: http://stackoverflow.com/questions/31628246/make-button-open-link-swift
// - Attribution: http://stackoverflow.com/questions/990221/multiple-lines-of-text-in-uilabel


import UIKit

class IssueDetailViewController: UIViewController {
    //Mark: Variables
    var passedData: [String]?
    
    //Mark: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    //Mark: Actions
    @IBAction func safariButton(_ sender: Any) {
        UIApplication.shared.open(URL(string: (passedData?[2])!)!, options: [:], completionHandler: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Set up titleLabel so it becomes a multiline label
        self.titleLabel.text = passedData?[4]
        self.titleLabel.lineBreakMode = .byWordWrapping
        self.titleLabel.numberOfLines = 0
        
        self.authorLabel.text = passedData?[1]
        self.dateLabel.text = passedData?[3]
        self.statusLabel.text = passedData?[0]
        
    }
        
}
