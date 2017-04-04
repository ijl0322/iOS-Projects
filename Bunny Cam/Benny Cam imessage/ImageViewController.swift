//
//  ImageViewController.swift
//  Bunny Cam
//
//  Created by Isabel  Lee on 07/03/2017.
//  Copyright © 2017 Isabel  Lee. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Photos


protocol sendPhotoDelegate: class{
    func sendPhoto(img: UIImage) -> Void
}

class ImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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

    weak var delegate: sendPhotoDelegate?
    var currentColor: UIColor = UIColor.red
    var currentFontSize = 30 //default font size is samll
    var currentText = ""
    
    @IBOutlet weak var photoButton: UIButton!
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
        
        print("add sticker pannel presented")
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
        
        print("add text pannel presented")
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
    @IBAction func menuButton(_ sender: UIButton) {
        print("menu item presented")
        menuButtonView.alpha = 1
        UIView.animate(withDuration: 0.1, animations: {
            self.infoButton.isHidden = false
        }, completion: { (finish: Bool) in UIView.animate(withDuration: 0.1, animations: {
            self.photoButton.isHidden = false
        }, completion: { (finish: Bool) in UIView.animate(withDuration: 0.1, animations: {
            self.saveButton.isHidden = false
        }, completion: {(finish: Bool) in UIView.animate(withDuration: 0.1, animations: {
            self.shareButton.isHidden = false
        }, completion: nil)})})})
    }
    
    //This function gets called when user tapped the show info button. 
    //Presents another view controller to show user how to use this app
    @IBAction func showInfo(_ sender: UIButton) {
        print("going to show info page")
        hideMenu()
        let vc = storyboard?.instantiateViewController(withIdentifier:
            "infoViewController")
        self.present(vc!, animated: true) {
        }
    }
    
    //This function gets called when user tapped the add photo button.
    //Presents a alert view controller to allow the user to choose photo from photo library 
    //or take photo using camera
    @IBAction func addPhoto(_ sender: UIButton) {
        print("photo picker launched")
        //launchPhotoPicker()
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        if self.checkPhotoLibraryAuthorization(){
            print("photo library access granted")
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: true){
                
            }
        } else {
            print("photo library access not granted")
            self.pleaseGrantAccessAlert(accessType: "photo library")
        }
    }
    
    //This function gets called when user tapped the save button
    //Also notifies the user that the photo has been saved
    @IBAction func savePhoto(_ sender: UIButton) {
        print("saving photo to album")
        UIImageWriteToSavedPhotosAlbum(editingImg.newImage, self, nil, nil)
        continueOrLeaveAlert()
        hideMenu()
    }
    
    //Call the delegate method of the protocol sendPhotoDelegate,
    //This will cause the app to go back to compact mode, and allow user to send this image via imessage to their friends
    @IBAction func sharePhoto(_ sender: UIButton) {
        print("share button tapped")
        delegate?.sendPhoto(img: editingImg.newImage)
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
        print("changing label size")
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
        
        editingImg.image = UIImage(named: "welcome")
        editingImg.oldImage = UIImage(named: "welcome")
        
        //MARK: Side Menu Setup
        infoButton.isHidden = true
        saveButton.isHidden = true
        shareButton.isHidden = true
        photoButton.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
        addTextView.isHidden = true
        addStickerView.isHidden = true
        addTextButton.backgroundColor = lightGrey
        addStickerButton.backgroundColor = lightGrey
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
            self.photoButton.isHidden = true
        }, completion: { (finish: Bool) in UIView.animate(withDuration: 0.1, animations: {
            self.infoButton.isHidden = true
        }, completion: nil)})})})
        
    }
    
    //Put the image the user picked into editingImg
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            self.editingImg.image = pickedImage
            self.editingImg.oldImage = pickedImage
            
        } else {
            print("Error adding image")
        }
        dismiss(animated: true, completion: nil)
    }
    
    //Lets user know that their photo has been saved
    func continueOrLeaveAlert() {
        let alert = UIAlertController(title: "", message: "Your Photo Has Been Saved", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //Prsent an alert view controller. Gives the user two options:
    // 1. Take a photo
    // 2. Pick a photo from photo library
    // Present the proper Image Picker Controller accordingly
    func launchPhotoPicker() {
        let alert = UIAlertController(title: "Get photos from:", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        alert.addAction(UIAlertAction(title: "Take a Photo", style: UIAlertActionStyle.default, handler: { (action) in
            print("camera")
            self.dismiss(animated: true, completion: nil)
            if self.checkCameraAuthorizationStatus(){
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.present(imagePicker, animated: true){
                    
                }
                print("camera access granted acess")
            } else {
                print("camera not granted")
                self.pleaseGrantAccessAlert(accessType: "camera")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Use photo library", style: UIAlertActionStyle.default, handler: { (action) in
            print("library")
            self.dismiss(animated: true, completion: nil)
            if self.checkPhotoLibraryAuthorization(){
                print("photo library access granted")
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self.present(imagePicker, animated: true){
                    
                }
            } else {
                print("photo library access not granted")
                self.pleaseGrantAccessAlert(accessType: "photo library")
            }
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //Check if the user has granted camera access, return true if yes, else return false
    func checkCameraAuthorizationStatus() -> Bool {
        let cameraMediaType = AVMediaTypeVideo
        let status =  AVCaptureDevice.authorizationStatus(forMediaType: cameraMediaType)
        switch status {
        case .denied: return false
        case .authorized: return true
        case .restricted: return false
            
        case .notDetermined:
            var requestFinish = false
            var status = false
            AVCaptureDevice.requestAccess(forMediaType: cameraMediaType) { granted in
                if granted {
                    print("Granted access to \(cameraMediaType)")
                    requestFinish = true
                    status = true
                } else {
                    print("Denied access to \(cameraMediaType)")
                    requestFinish = true
                }
            }
            while (requestFinish == false) {
                
            }
            return status
        }
        
    }
    
    //Check if the user has granted photo library access, return true if yes, else return false
    func checkPhotoLibraryAuthorization() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .denied: return false
        case .authorized: return true
        case .restricted: return false
            
        case .notDetermined:
            var requestFinish = false
            var status = false
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    print("Granted access to photo Library")
                    requestFinish = true
                    status = true
                }
                else {
                    print("Denied access to photo Library")
                    requestFinish = true
                }
            })
            
            while (requestFinish == false) {
                
            }
            return status
        }
    }
    
    
    //Present an alert view controller to ask user to grant access to camera or photo library.
    //It seems like taking the user to settings is not available in the imessage extension
    //So instead of directing the user to settings(like in Benny Cam), this just gives the user direction to grant access
    func pleaseGrantAccessAlert(accessType: String){
        let alert = UIAlertController(title: "Please grant access", message: "Benny cam need to access your \(accessType) to put cute bunnies on your photo! Go to settings > Benny Cam to grant permission!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        present(alert, animated: true, completion: nil)
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
