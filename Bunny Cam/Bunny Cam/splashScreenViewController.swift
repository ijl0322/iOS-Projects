//
//  splashScreenViewController.swift
//  Bunny Cam
//
//  Created by Isabel  Lee on 09/03/2017.
//  Copyright © 2017 Isabel  Lee. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    override func viewDidLoad() {
         super.viewDidLoad()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateInitialViewController() as! NavigationController
            self.view.window?.rootViewController = viewController
        
        
        }
        
    }
    
}
