//
//  ImageViewController.swift
//  Bunny Cam
//
//  Created by Isabel  Lee on 25/02/2017.
//  Copyright © 2017 Isabel  Lee. All rights reserved.
//

// - Attribution: https://www.ioscreator.com/tutorials/segmented-control-tutorial-ios10
// - Attribution: http://stackoverflow.com/questions/3460694/uibutton-wont-go-to-aspect-fit-in-iphone/3995820#3995820
// - Attribution: http://stackoverflow.com/questions/1054558/vertically-align-text-to-top-within-a-uilabel/1054681#1054681
// - Attribution: https://www.raywenderlich.com/114552/uistackview-tutorial-introducing-stack-views

// - Attribution: http://stackoverflow.com/questions/12509422/how-to-perform-unwind-segue-programmatically
// - Attribution: http://stackoverflow.com/questions/26961274/how-can-i-make-a-button-have-a-rounded-border-in-swift

// - Attribution: Checking camera access : http://stackoverflow.com/questions/27646107/how-to-check-if-the-user-gave-permission-to-use-the-camera

import UIKit

class ImageViewController: UIViewController{
    
    //MARK: Color palette
    let lightGrey = UIColor(red: 227/255, green: 228/255, blue: 229/255, alpha: 1)
    let darkGrey = UIColor(red: 199/255, green: 200/255, blue: 201/255, alpha: 1)
    let red = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
    let blue = UIColor(red: 22/255, green: 105/255, blue: 186/255, alpha: 1)
    let black = UIColor(red: 35/255, green: 34/255, blue: 34/255, alpha: 1)
    let purple = UIColor(red: 114/255, green: 46/255, blue: 178/255, alpha: 1)
    let babyBlue = UIColor(red: 135/255, green: 206/255, blue: 250/255, alpha: 1)
    let green = UIColor(red: 149/255, green: 247/255, blue: 54/255, alpha: 1)
    let orange = UIColor(red: 250/255, green: 140/255, blue: 0/255, alpha: 1)
    let pink = UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1)
    let beige = UIColor(red: 255/255, green: 255/255, blue: 224/255, alpha: 1)
    let lightPurple = UIColor(red: 232/255, green: 157/255, blue: 249/255, alpha: 1)
    let turquiose = UIColor(red: 64/255, green: 224/255, blue: 208/255, alpha: 1)
    var colorArray:[UIColor] = []
    
    //MARK: Variables
    let stickersArray = [UIImage(named: "1"), UIImage(named: "2"), UIImage(named: "3"), UIImage(named: "4"), UIImage(named: "5"), UIImage(named: "6"), UIImage(named: "7"), UIImage(named: "8"), UIImage(named: "9"), UIImage(named: "10"), UIImage(named: "11"), UIImage(named: "12"), UIImage(named: "13"), UIImage(named: "14"), UIImage(named: "15"), UIImage(named: "16"), UIImage(named: "17"), UIImage(named: "18"), UIImage(named: "19"), UIImage(named: "20"), UIImage(named: "21"), UIImage(named: "22"), UIImage(named: "23"), UIImage(named: "24"), UIImage(named: "25"), UIImage(named: "26"), UIImage(named: "27"), UIImage(named: "28"), UIImage(named: "29"), UIImage(named: "30"), UIImage(named: "31"), UIImage(named: "32"), UIImage(named: "33"), UIImage(named: "34"), UIImage(named: "35"), UIImage(named: "36"), UIImage(named: "37"), UIImage(named: "38"), UIImage(named: "39"), UIImage(named: "40")]
    var currentColor: UIColor = UIColor.red
    var userImg: UIImage?
    var currentFontSize = 30 //default font size is samll
    var currentText = ""
    
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var menuButtonView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addTextButton: UIButton!
    @IBOutlet weak var addStickerButton: UIButton!
    @IBOutlet weak var addTextView: UIView!
    @IBOutlet weak var addStickerView: UIView!
    @IBOutlet weak var editingImg: editorImageView!
    @IBOutlet weak var fontSizeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    
    //MARK: Properties
    
    //This function gets called when the user click the add Sticker button.
    //It shows the add Sticker pannel and sets the background color of the add Sticker button to a darker grey
    @IBAction func addSticker(_ sender: UIButton) {
        print("Sticker pannel presented")
        if self.addTextView.isHidden {
            UIView.animate(withDuration: 0.3){
                self.addStickerView.isHidden = false
            }
        } else {
            self.addTextView.isHidden = true
            self.addStickerView.isHidden = false
        }
        
        addTextButton.backgroundColor = lightGrey
        addStickerButton.backgroundColor = darkGrey
    }

    
    //This function gets called when the user click the add Text button.
    //It shows the add Text pannel and sets the background color of the add Text button to a darker grey
    @IBAction func addText(_ sender: UIButton) {
        
        print("Text pannel presented")
        if self.addStickerView.isHidden {
            UIView.animate(withDuration: 0.3){
                self.addTextView.isHidden = false
            }
        } else {
            self.addStickerView.isHidden = true
            self.addTextView.isHidden = false
        }
        
        addTextButton.backgroundColor = darkGrey
        addStickerButton.backgroundColor = lightGrey
    
    }
    
    //This function gets called when user tapped on the menu button.
    //Presents the buttons in the menu
    @IBAction func menuButton(_ sender: UIBarButtonItem) {
        print("menu item presented")
        menuButtonView.alpha = 1
        UIView.animate(withDuration: 0.1, animations: {
            self.infoButton.isHidden = false
        }, completion: { (finish: Bool) in UIView.animate(withDuration: 0.1, animations: {
            self.saveButton.isHidden = false
        }, completion: { (finish: Bool) in UIView.animate(withDuration: 0.1, animations: {
            self.shareButton.isHidden = false
        }, completion: nil)})})
    }
    
    //This function gets called when user tapped the show info button.
    //Presents another view controller to show user how to use this app
    @IBAction func showInfo(_ sender: UIButton) {
        print("presenting show info view controller")
        hideMenu()
        let vc = storyboard?.instantiateViewController(withIdentifier:
            "infoViewController")
        self.present(vc!, animated: true) {
        }
    }
    
    //This function gets called when user tapped the save button
    //Also notifies the user that the photo has been saved
    @IBAction func savePhoto(_ sender: UIButton) {
        print("saving photo")
        UIImageWriteToSavedPhotosAlbum(editingImg.newImage, self, nil, nil)
        continueOrLeaveAlert()
        hideMenu()
    }
    
    //Present an activity view controller to allow user to share photo via facebook/ twitter....
    @IBAction func sharePhoto(_ sender: UIButton) {
        print("share button tapped")
        let shareArray = [editingImg.newImage]
        let activityViewController = UIActivityViewController(activityItems: shareArray, applicationActivities: nil)
        
        //on ipads, activity view controllers are presented as popOvers.
        if let popoverActivityVC = activityViewController.popoverPresentationController {
            popoverActivityVC.sourceView = sender as UIView
            popoverActivityVC.sourceRect = sender.bounds
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    //This function gets called when the user click the OK button on the text editing pannel.
    //Adds the text the user inputted to the user's photo, and dismiss the text editting pannel.
    @IBAction func okButton(_ sender: UIButton) {
        print("ok Button tapped")
        
        if currentText != ""{
            self.editingImg.addText(text: currentText, fontSize: currentFontSize, color: currentColor)
        }
        
        if self.addTextView.isHidden == false {
            UIView.animate(withDuration: 0.1){
                self.addTextView.isHidden = true
                self.addTextButton.backgroundColor = self.lightGrey
                self.textField.text = ""
                self.currentText = ""
            }
        }
    }
    
    //This function gets called when the user change the font size in the text editing pannel.
    //Changes the font size accordingly
    @IBAction func changeFontSize(_ sender: UISegmentedControl) {
        print("changing font size")
        switch fontSizeSegmentedControl.selectedSegmentIndex {
        case 0:
            print("Label size: Small")
            currentFontSize = 30
        case 1:
            print("Label size: Normal")
            currentFontSize = 40
        case 2:
            print("Label size: Large")
            currentFontSize = 50
        default:
            return
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if let userImg = userImg {
            editingImg.image = userImg
            editingImg.oldImage = userImg
        }
        
        
        //MARK: CollectionView Set Up
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "stickerCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        //MARK: Editor Pannel Set Up
        colorArray = [red, orange, green, turquiose, babyBlue, beige, black, pink, lightPurple, blue, purple]
        
        addTextButton.imageView?.contentMode = .scaleAspectFit
        addStickerButton.imageView?.contentMode = .scaleAspectFit
        addTextView.isHidden = true
        addStickerView.isHidden = true
        addTextButton.backgroundColor = lightGrey
        addStickerButton.backgroundColor = lightGrey
        textField.delegate = self
        
        let hidePannelGesture = UITapGestureRecognizer(target: self, action: #selector(hideEditPannel(_:)))
        hidePannelGesture.numberOfTapsRequired = 2
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(hidePannelGesture)
        
        for i in 1...11 {
            if let tempButton = self.view.viewWithTag(i) as? UIButton {
                tempButton.addTarget(self, action: #selector(buttonTapped), for: UIControlEvents.touchUpInside)
                
                tempButton.layer.borderColor = self.darkGrey.cgColor
                if i == 1 {
                    tempButton.layer.borderWidth = 3
                    currentColor = red
                }
            }
        }
        
        //MARK: Side Menu Setup
        infoButton.isHidden = true
        saveButton.isHidden = true
        shareButton.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
        addTextView.isHidden = true
        addStickerView.isHidden = true
        addTextButton.backgroundColor = lightGrey
        addStickerButton.backgroundColor = lightGrey
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //This function hides the edit pannel (add Sticker/ add text pannel)
    //And also hides the menu
    //Basically hides every thing that may obscure the user's view of the image being edited
    func hideEditPannel(_ recognizer:UITapGestureRecognizer) {
        if self.addTextView.isHidden == false {
            UIView.animate(withDuration: 0.1){
                self.addTextView.isHidden = true
                self.addTextButton.backgroundColor = self.lightGrey
                self.textField.text = ""
                self.currentText = ""
            }
        }
        if self.addStickerView.isHidden == false {
            UIView.animate(withDuration: 0.1){
                self.addStickerView.isHidden = true
                self.addStickerButton.backgroundColor = self.lightGrey
            }
        }
        hideMenu()
    }
    
    //This function gets triggered when user taps a color button.
    //It shows a border around the color that is currently chosen.
    func buttonTapped(_ button: UIButton!) {
        print("Change color to #\(button.tag)")
        self.currentColor = self.colorArray[button.tag-1]
        for i in 1...11 {
            if let tempButton = self.view.viewWithTag(i) as? UIButton {
                tempButton.layer.borderWidth = 0
            }
        }
        button.layer.borderWidth = 3
    }
    
    //Hides all buttons in the menu using a simple animation
    func hideMenu() {
        UIView.animate(withDuration: 0.1, animations: {
            self.shareButton.isHidden = true
        }, completion: { (finish: Bool) in UIView.animate(withDuration: 0.1, animations: {
            self.saveButton.isHidden = true
        }, completion: { (finish: Bool) in UIView.animate(withDuration: 0.1, animations: {
            self.infoButton.isHidden = true
        }, completion: nil)})})
    }
    
    @IBAction func unwindToIVC(sender: UIStoryboardSegue) {
        
    }
    
    //Lets user know that their photo has been saved
    func continueOrLeaveAlert() {
        let alert = UIAlertController(title: "", message: "Your Photo Has Been Saved", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Continue Editing", style: UIAlertActionStyle.default, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction(title: "Choose Another Photo", style: UIAlertActionStyle.default, handler: { (action) in
            self.performSegue(withIdentifier: "backToRoot", sender: Any?.self)
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

extension ImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stickersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stickerCell", for: indexPath) as! CollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let imageCell = cell as! CollectionViewCell
        imageCell.stickerImage.image = stickersArray[indexPath.row]
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/4, height: view.frame.width/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Sticker #\(indexPath.row) Chosen")
        let imageName = indexPath.row + 1
        self.editingImg.addSticker(imageName: String(imageName))
        if self.addStickerView.isHidden == false {
            UIView.animate(withDuration: 0.1){
                self.addStickerView.isHidden = true
                self.addStickerButton.backgroundColor = self.lightGrey
            }
        }
        
    }
    
}

extension ImageViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if let text = textField.text {
            print("Text Entered: \(text)")
            currentText = text
        }
        return
    }
}

