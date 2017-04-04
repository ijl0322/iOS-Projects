//
//  editorImageView.swift
//  Bunny Cam
//
//  Created by Isabel  Lee on 07/03/2017.
//  Copyright © 2017 Isabel  Lee. All rights reserved.
//

//  - Attribution: http://stackoverflow.com/questions/27975954/screenshot-only-part-of-screen-swift/33633581
//  - Attribution: http://stackoverflow.com/questions/29859995/screenshot-showing-up-blank-swift/33633386#33633386
//  - Attribution: http://www.jianshu.com/p/f80e2b57f304
//  - Attribution: http://stackoverflow.com/questions/27975954/screenshot-only-part-of-screen-swift


import UIKit
import AVFoundation

//The editorImageView is a sub class of UIImageVIew. 
//This allows the program to add stickers and textBoxes to the image as subviews
//And to get the edited image(including the user's image + all the stickers/ textBoxes the user added)
class editorImageView: UIImageView {
    
    var oldImage: UIImage!
    var deleteOptionView: UIImageView!
    var deleteButton: UIButton!
    var dontDeleteButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isUserInteractionEnabled = true
        deleteOptionView = UIImageView(image: UIImage(named: "greyBox"))
        deleteOptionView.frame = CGRect(x: 0, y: 0, width: 200, height: 128)
        deleteOptionView.center.x = self.center.x
        deleteOptionView.center.y = self.center.y
        deleteOptionView.alpha = 0
        self.addSubview(deleteOptionView)
        
    }
    
    // This captures a screen shot of the user image and all subviews of that image (including stickers and text boxes)
    var newImage: UIImage {
        get {

            let newFrame = AVMakeRect(aspectRatio: oldImage.size, insideRect: self.bounds);
            UIGraphicsBeginImageContextWithOptions(newFrame.size, true, 0)
            print("Bound width: \(bounds.size.width), New Width: \(newFrame.width)")
            print("Bound height: \(bounds.size.height), New height: \(newFrame.height)")
            drawHierarchy(in: CGRect(x: -(bounds.size.width - newFrame.width)/2, y: -(bounds.size.height - newFrame.height)/2, width: bounds.size.width, height: bounds.size.height), afterScreenUpdates: true)
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result!
        }
    }
    
    //Add a sticker to the user's image
    func addSticker(imageName: String){
        let newSticker = stickers(imageName: imageName)
        self.addSubview(newSticker)
    }
    
    //Add a text to the user's image
    func addText(text: String, fontSize: Int, color: UIColor) {
        print("Text label: \(text) add to image")
        let newText = textBox()
        newText.text = "  " + text + "  "
        newText.textColor = color
        newText.font = newText.font.withSize(CGFloat(fontSize))
        newText.sizeToFit()
        
        self.addSubview(newText)
    }
    
}
