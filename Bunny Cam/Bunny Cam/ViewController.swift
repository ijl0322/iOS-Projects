//
//  ViewController.swift
//  Bunny Cam
//
//  Created by Isabel  Lee on 25/02/2017.
//  Copyright © 2017 Isabel  Lee. All rights reserved.
//  -Attribution: http://stackoverflow.com/questions/5655674/opening-the-settings-app-from-another-app
//  -Attribution: http://stackoverflow.com/questions/26595343/determine-if-the-access-to-photo-library-is-set-or-not-ios-8

import UIKit
import AVFoundation
import Photos

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    var userImg: UIImage?
    
    let imagePicker = UIImagePickerController()
    
    
    //Lets user take a photo from the camera and edit the photo.
    //First checks if they user granted access to the camera
    @IBAction func camera(_ sender: UIButton) {
        
        if checkCameraAuthorizationStatus(){
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(imagePicker, animated: true){
                
            }
            print("camera access granted acess")
        } else {
            print("camera not granted")
            pleaseGrantAccessAlert(accessType: "camera")
        }
    }
    
    
    //Lets user choose a photo from the photo library and edit the photo.
    //First checks if they user granted access to the photo library
    @IBAction func library(_ sender: UIButton) {
        
        if checkPhotoLibraryAuthorization(){
            print("photo library access granted")
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: true){
                
            }
        } else {
            print("photo library access not granted")
            pleaseGrantAccessAlert(accessType: "photo library")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        
        //Setting First Launch Date if it has not been set
        if let firstLaunch = UserDefaults.standard.object(forKey: "firstLaunchDate") {
            print("First Launch Date is set already to \(firstLaunch)")
        } else {
            print("\(NSDate())")
            let today = NSDate()
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            let new = formatter.string(from: today as Date)
            UserDefaults.standard.set(new, forKey: "firstLaunchDate")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }

    
    //After the user picks a photo(from camera or photo library, 
    //perform segue and send that phto to the imageViewController)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{

            self.userImg = pickedImage
            self.performSegue(withIdentifier: "imageViewSegue", sender: self)
            print("imageViewSegue perform")

        } else {
            print("Error adding image")
        }
        dismiss(animated: true, completion: nil)

    }
    
    //Send image to imageViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "imageViewSegue"{
            let vc = segue.destination as! ImageViewController
            vc.userImg = userImg
        }
    }
    
    @IBAction func unwindToVC(sender: UIStoryboardSegue) {
        print("Unwinded from \(sender.identifier)")

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
    //Takes user to the settings page when they click "OK"
    func pleaseGrantAccessAlert(accessType: String){
        let alert = UIAlertController(title: "Please grant access", message: "Benny cam need to access your \(accessType) to put cute bunnies on your photo!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            UIApplication.shared.open(NSURL(string:UIApplicationOpenSettingsURLString)! as URL, options: [:], completionHandler: nil)
        }))
        
         present(alert, animated: true, completion: nil)
    }
    
}

