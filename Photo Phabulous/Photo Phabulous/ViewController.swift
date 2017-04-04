//
//  ViewController.swift
//  Photo Phabulous
//
//  Created by Isabel  Lee on 20/02/2017.
//  Copyright © 2017 Isabel  Lee. All rights reserved.
//

// - Attribution: https://www.youtube.com/watch?v=a89c67TIh10
// - Attribution: https://www.youtube.com/watch?v=dfy7tu5m-p8
// - Attribution: https://www.youtube.com/watch?v=a89c67TIh10
// - Attribution: http://www.appcoda.com/social-framework-introduction/
// - Attribution: https://www.youtube.com/watch?v=BIgqHLTZ_a4  Caching images using NSCache
// - Attribution: https://thatthinginswift.com/writing-documents-directory-swift/

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: Variables
    
    var imageArray : [UIImage] = []
    
    var imageUrl: [String] = []
    
    var imageCount = 0
    
    var newImage: UIImage?
    
    var selectedImage: UIImage?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Properties

    @IBAction func Refresh(_ sender: UIButton) {
        refreshData()
    }
    
    @IBAction func camera(_ sender: UIBarButtonItem) {
        launchPhotoPicker()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up collection View
        
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //try to fetch data from Documents
        //if fetched successfully, try to download the images( will also check if image is stored in cache already)
        let docs = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        if let cachedUrl = NSKeyedUnarchiver.unarchiveObject(withFile: docs + "/imagejson.plist") as! [String]?{
            dump(cachedUrl)
            self.imageUrl = cachedUrl
            for url in self.imageUrl {
                self.downloadImages(url: url)
            }
        } else {
            refreshData()    //Connect to the main server and download Json/images
        }
    }
        
    //sets up a imagePickerController. If user picked a photo, add the image to the collection view and upload it to server
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            newImage = pickedImage
            addImage()
            self.uploadRequest(user: "ijlee", image: pickedImage, caption: "myImage") { (bool) in
                if bool {
                    self.refreshData()
                } else {
                    self.errorAlert(alert: "Failed to upload image")
                }
            }
            
        } else {
            print("Error adding image")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //when user tapped the camera button, present a UIAlertController and allow the user to add from camera or add from photolibrary. 
    //then present the imagePickerController accorindly
    func launchPhotoPicker() {
        let alert = UIAlertController(title: "Get photos from:", message: "Get photos from:", preferredStyle: UIAlertControllerStyle.alert)
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        alert.addAction(UIAlertAction(title: "Take a Photo", style: UIAlertActionStyle.default, handler: { (action) in
            print("camera")
            self.dismiss(animated: true, completion: nil)
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(imagePicker, animated: true){
                
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Use photo library", style: UIAlertActionStyle.default, handler: { (action) in
            print("library")
            self.dismiss(animated: true, completion: nil)
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: true){
                
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //add a new image to the collection view
    func addImage(){
        imageArray.append(newImage!)
        let index = imageArray.index(where : {$0 == newImage})
        let indexPath = IndexPath(item: index!, section: 0)
        self.collectionView.performBatchUpdates({Void in
            self.collectionView.insertItems(at: [indexPath])
            self.imageCount += 1
        }, completion: nil)
    }
    
    //pass the image tapped by the user to the ImageViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailViewSegue"{
            let vc = segue.destination as! ImageViewController
            vc.image = selectedImage
        }
    }
    
    //download an image at the url, and add it to the image array
    func downloadImages(url: String){
        SharedNetworking.sharedInstance.downloadPhoto(imgUrl: url, completion: { (img, error) in
            DispatchQueue.main.async {
                if error != nil {
                    print("can't download image")
                }
                if let newImage = img {
                    self.imageArray.append(newImage)
                    self.imageCount = self.imageArray.count
                    self.collectionView.reloadData()
                }
            }
        })
    }
    
    //post the newly added photo to server
    func uploadRequest(user: NSString, image: UIImage, caption: NSString, completion: @escaping (Bool)->Void){
        
        let boundary = generateBoundaryString()
        let scaledImage = resize(image: image, scale: 0.5)
        let imageJPEGData = UIImageJPEGRepresentation(scaledImage,0.1)
        
        guard let imageData = imageJPEGData else {return}
        
        // Create the URL, the user should be unique
        let url = NSURL(string: "http://stachesandglasses.appspot.com/post/\(user)/")
        
        // Create the request
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Set the type of the data being sent
        let mimetype = "image/jpeg"
        // This is not necessary
        let fileName = "img1.jpg"
        
        // Create data for the body
        let body = NSMutableData()
        body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        
        // Caption data
        body.append("Content-Disposition:form-data; name=\"caption\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("CaptionText\r\n".data(using: String.Encoding.utf8)!)
        
        // Image data
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"image\"; filename=\"\(fileName)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        
        // Trailing boundary
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        // Set the body in the request
        request.httpBody = body as Data
        
        // Create a data task
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            // Need more robust errory handling here
            // 200 response is successful post
            
            if error != nil {
                self.errorAlert(alert: "Cannot upload photo to server")
                completion(false)
            } else {
                print(response!)
                //print(error)
                
                // The data returned is the update JSON list of all the images
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(dataString!)
                completion(true)
                
            }
        }
        
        task.resume()
    }
    
    /// A unique string that signifies breaks in the posted data
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func resize(image: UIImage, scale: CGFloat) -> UIImage {
        let size = image.size.applying(CGAffineTransform(scaleX: scale,y: scale))
        let hasAlpha = true
        
        // Automatically use scale factor of main screen
        let scale: CGFloat = 0.0
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
    
    // present a UIAlertViewController to inform user that some problem occured
    func errorAlert(alert: String) {
        let message = "Opps..Something bad happend"
        let alert = UIAlertController(title: alert,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func refreshData(){
        //get the newest version of the data from server, and reload data
        SharedNetworking.sharedInstance.loadData(completion: { (imgUrl, error) in
            DispatchQueue.main.async {
                if error != nil {
                    self.errorAlert(alert: "Error loading photos")
                } else {
                    self.imageUrl = []
                    self.imageArray = []
                    self.imageCount = 0
                    if let imgUrl = imgUrl {
                        self.imageUrl = imgUrl
                        dump(self.imageUrl)
                        for url in self.imageUrl {
                            self.downloadImages(url: url)
                        }
                    }
                }
            }
        })
        
    }
    
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        cell.awakeFromNib()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let imageCell = cell as! CollectionViewCell
        imageCell.imageView.image = imageArray[indexPath.row]
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/4, height: view.frame.width/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        selectedImage = imageArray[indexPath.row]
        self.performSegue(withIdentifier: "detailViewSegue", sender: Any?.self)
        
    }
}

