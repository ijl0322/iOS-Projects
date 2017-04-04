//
//  infoViewController.swift
//  Bunny Cam
//
//  Created by Isabel  Lee on 07/03/2017.
//  Copyright © 2017 Isabel  Lee. All rights reserved.
//

//
//  infoViewController.swift
//  Bunny Cam
//
//  Created by Isabel  Lee on 02/03/2017.
//  Copyright © 2017 Isabel  Lee. All rights reserved.
//  - Attribution: http://qiita.com/suzukihr/items/903530e9d09aae6ba950


import UIKit

class infoViewController: UIViewController {
    
    let instructions = [UIImage(named: "inst1"), UIImage(named: "inst2"), UIImage(named: "inst3"), UIImage(named: "inst4")]
    
    @IBOutlet weak var infoImage: UIImageView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBAction func okButton(_ sender: UIButton) {
        print("dismissing info view controller")
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft(_:)))
        swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirection.left
        let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight(_:)))
        swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirection.right
        infoImage.isUserInteractionEnabled = true
        infoImage.addGestureRecognizer(swipeLeftGestureRecognizer)
        infoImage.addGestureRecognizer(swipeRightGestureRecognizer)
        infoImage.image = instructions[0]
        infoImage.contentMode = .scaleAspectFit
        
    }
    
    //Handles swipe left gesture(change the page of the information)
    func swipeLeft(_ recognizer: UISwipeGestureRecognizerDirection){
        
        if pageControl.currentPage < 3 {
            pageControl.currentPage += 1
            infoImage.image = instructions[pageControl.currentPage]
        }
    }
    
    //Handles swipe right gesture(change the page of the information)
    func swipeRight(_ recognizer: UISwipeGestureRecognizerDirection){
        
        if pageControl.currentPage > 0 {
            pageControl.currentPage -= 1
            infoImage.image = instructions[pageControl.currentPage]
        }
    }
    
}

