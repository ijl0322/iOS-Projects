//
//  InfoViewController.swift
//  TicTacToe
//
//  Created by Isabel  Lee on 08/02/2017.
//  Copyright © 2017 Isabel  Lee. All rights reserved.
//


// - Attribution: http://stackoverflow.com/questions/34854880/adding-blur-effect-to-background-of-a-log-in-view-controller-in-swift

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var textLabel: UILabel!
    var passedData: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set up textLabel so that contens will appear in multiline mode
        self.textLabel.lineBreakMode = .byWordWrapping
        self.textLabel.numberOfLines = 0
        
        //This is just for fun. Pretty nice visual effect of a blurred board
        let imageView = UIImageView(image: UIImage(named: "blur"))
        imageView.frame = view.bounds
        imageView.contentMode = .scaleToFill
        view.insertSubview(imageView, at: 0)
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = imageView.bounds
        view.insertSubview(blurredEffectView, at: 1)
    }
    
    
    //When the segue is triggered, and this view appears, the ViewController passed in a string 
    //to passedData. Which is either a "x"(signify x wins), an "o"(o wins), an "E" (tie), or
    //"info" (which means we want to see the how to play information). This block sets up the
    //labels accordingly.
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if passedData == "x"{
            titleLabel.text = "Player X Wins!"
            textLabel.text = "Sorry Player O :("
        } else if passedData == "o" {
            titleLabel.text = "Player O Wins!"
            textLabel.text = "Sorry Player X :("
        } else if passedData == "info" {
            titleLabel.text = "How to Play"
            textLabel.text = "Two players take turns dragging the icons into the blocks. Whoever makes a connection of 3 first wins!"
        } else if passedData == "E" {
            titleLabel.text = "It's a Tie!"
            textLabel.text = "Try Again!"
        }
        
    }
}
