//
//  ImageViewController.swift
//  Photo Phabulous
//
//  Created by Isabel  Lee on 22/02/2017.
//  Copyright © 2017 Isabel  Lee. All rights reserved.
//


// - Attribution: http://stackoverflow.com/questions/26273672/how-to-hide-status-bar-and-navigation-bar-when-tap-device
// Note : The navigation bar hides when a user taps the screen. There is a convenient function that does exactly this:
// navigationController?.hidesBarsOnTap = true
// however, it will also hide the navigation bar in the all other view controllers, so it is not used here. 


import UIKit
import Social

class ImageViewController: UIViewController {
    
    var navigationBarHidden = false
    var image: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func shareButton(_ sender: UIBarButtonItem) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
            let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            vc?.add(image)
            present(vc!, animated: true, completion: nil)
        } else {
            print("Service not available")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = image {
            self.imageView.image = image
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideNavigationBar(_:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gesture)
    }
    
    func hideNavigationBar(_ recognizer:UITapGestureRecognizer) {
        if navigationBarHidden {
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationBarHidden = false
        } else {
            navigationController?.setNavigationBarHidden(true, animated: true)
            navigationBarHidden = true
        }
    }
}
