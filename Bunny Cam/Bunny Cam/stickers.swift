//
//  stickers.swift
//  Bunny Cam
//
//  Created by Isabel  Lee on 02/03/2017.
//  Copyright © 2017 Isabel  Lee. All rights reserved.
//  - Attribution: https://www.youtube.com/watch?v=QawWEr2jDl0
//  - Attribution:http://stackoverflow.com/questions/22191582/how-to-reduce-velocity-of-pinch-zoom-uigesturerecognizer
//  I used the animation function that was provied in the Collection View example

import UIKit

//This class is a sub class of UIImageVIew
//This is the sticker added to the user's image when a user wants to stickers
//This stickers detects different gestures to allow user to move/ rotate/ change size/ delete the text box
class stickers: UIImageView, UIGestureRecognizerDelegate {
    
    init(imageName: String) {
        let sticker = UIImage(named: imageName)
        super.init(image: sticker)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(self.handleRotation(_:)))
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinch(_:)))
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        panGestureRecognizer.delegate = self
        rotationGestureRecognizer.delegate = self
        pinchGestureRecognizer.delegate = self
        longPressGestureRecognizer.delegate = self
        longPressGestureRecognizer.minimumPressDuration = 1.5
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(panGestureRecognizer)
        self.addGestureRecognizer(rotationGestureRecognizer)
        self.addGestureRecognizer(pinchGestureRecognizer)
        self.addGestureRecognizer(longPressGestureRecognizer)
        self.frame = CGRect(x: 150, y: 150, width: 150, height: 150)
        self.contentMode = .scaleAspectFit
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Allow user to use pan gesture to move stickers
    func handlePan(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: recognizer.view)
        
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        
        recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
    }
    
    //Allow user to use rotation gesture to rotate stickers
    func handleRotation(_ recognizer: UIRotationGestureRecognizer) {
        recognizer.view!.transform = recognizer.view!.transform.rotated(by: recognizer.rotation)
        recognizer.rotation = 0
    }
    
    //Allow user to use pinch gesture to change the size of the sticker
    func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
        recognizer.view!.transform = recognizer.view!.transform.scaledBy(x: (recognizer.scale), y: (recognizer.scale))

        recognizer.scale = 1
    }
    
    //Allow user to use long press gesture to delete stickers
    func handleLongPress(_ recognizer: UILongPressGestureRecognizer) {

        if let view = recognizer.view {
            
            let angle = 0.05
            
            let wiggle = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            wiggle.values = [-angle, angle]
            
            wiggle.autoreverses = true
            wiggle.duration = self.randomInterval(0.1, variance: 0.025)
            wiggle.repeatCount = Float.infinity
            wiggle.isAdditive = true
            view.layer.add(wiggle, forKey: "wiggle")
            
            
            let button: UIButton = UIButton(frame: CGRect(x: 0 , y: 0, width: 30.0, height: 30.0))
            button.setImage(UIImage(named: "deleteButton"), for: .normal)
            view.addSubview(button)
            button.addTarget(self, action: #selector(buttonTapped), for: UIControlEvents.touchUpInside)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4){
                button.removeFromSuperview()
                view.layer.removeAllAnimations()
            }
        }
        
    }
    
    func buttonTapped(_ button: UIButton!) {
        
        self.removeFromSuperview()
    }
    
    //Generate a random interval for the animation. This function is
    //copied from the Collection View example provided in class
    func randomInterval(_ interval: TimeInterval, variance: Double) -> TimeInterval {
        return interval + variance * Double((Double(arc4random_uniform(1000)) - 500.0) / 500.0)
    }
    

}
