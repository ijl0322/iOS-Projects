//
//  StickerViewController.swift
//  Bunny Cam
//
//  Created by Isabel  Lee on 07/03/2017.
//  Copyright © 2017 Isabel  Lee. All rights reserved.
//

import Foundation
import UIKit
import Messages

//This is the protocol that lets the MessagesViewController know that the user clicked 
//the add button and want to creat their custom image
protocol stickerViewDelegate: class {
    func createImage() -> Void
}

//The collectionViewItems contain two kind of items, the create button, and the MSStickers
enum collectionViewItems {
    case create
    case sticker(MSSticker)
}

class StickerViewController: UIViewController {
    var stickers = [collectionViewItems]()
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: stickerViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        loadStickers()
        stickers.insert(.create, at: 0)
    }
    
    
    //load all the stickers into the stickers array
    func loadStickers() {
        createSticker(asset: "1", localizedDescription: "Laugh")
        createSticker(asset: "2", localizedDescription: "Presents")
        createSticker(asset: "3", localizedDescription: "Proud")
        createSticker(asset: "4", localizedDescription: "Thanks")
        createSticker(asset: "5", localizedDescription: "Sleepless")
        createSticker(asset: "6", localizedDescription: "Charming")
        createSticker(asset: "7", localizedDescription: "Hi")
        createSticker(asset: "8", localizedDescription: "Cooking")
        createSticker(asset: "9", localizedDescription: "Crying")
        createSticker(asset: "10", localizedDescription: "Sorry")
        createSticker(asset: "11", localizedDescription: "Reading")
        createSticker(asset: "12", localizedDescription: "Please")
        createSticker(asset: "13", localizedDescription: "Love")
        createSticker(asset: "14", localizedDescription: "Hmm")
        createSticker(asset: "15", localizedDescription: "You sure?")
        createSticker(asset: "16", localizedDescription: "Sigh")
        createSticker(asset: "17", localizedDescription: "Angry")
        createSticker(asset: "18", localizedDescription: "Good Night")
        createSticker(asset: "19", localizedDescription: "Full")
        createSticker(asset: "20", localizedDescription: "Sick")
        createSticker(asset: "21", localizedDescription: "See you!")
        createSticker(asset: "22", localizedDescription: "Annoyed")
        createSticker(asset: "23", localizedDescription: "Flowers")
        createSticker(asset: "24", localizedDescription: "What?")
        createSticker(asset: "25", localizedDescription: "Shy")
        createSticker(asset: "26", localizedDescription: "Annoyed by the rain")
        createSticker(asset: "27", localizedDescription: "Scared")
        createSticker(asset: "28", localizedDescription: "Great")
        createSticker(asset: "29", localizedDescription: "Let's Eat")
        createSticker(asset: "30", localizedDescription: "Happy Birthday")
        createSticker(asset: "31", localizedDescription: "Whatever")
        createSticker(asset: "32", localizedDescription: "Just Chilling")
        createSticker(asset: "33", localizedDescription: "You're awesome")
        createSticker(asset: "34", localizedDescription: "Defeated")
        createSticker(asset: "35", localizedDescription: "Yay")
        createSticker(asset: "36", localizedDescription: "Dizzy")
        createSticker(asset: "37", localizedDescription: "OK")
        createSticker(asset: "38", localizedDescription: "Don't know")
        createSticker(asset: "39", localizedDescription: "Cheerful")
        createSticker(asset: "40", localizedDescription: "Showering")

    }
    
    //This creates a sticker and and add it to the sticker array
    func createSticker(asset: String, localizedDescription: String) {
        guard let stickerPath = Bundle.main.path(forResource: asset, ofType: "png") else {
            print("couldn't create the sticker path for ", asset)
            return
        }
        let stickerURL = URL(fileURLWithPath: stickerPath)
        
        let sticker: MSSticker
        do {
            try sticker = MSSticker(contentsOfFileURL: stickerURL, localizedDescription: localizedDescription)
            stickers.append(.sticker(sticker))
        } catch {
            print(error)
            return
        }
    }
    
}

extension StickerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stickers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = stickers[indexPath.row]
        switch item {
        case .sticker(let sticker):
            return dequeueStickerCell(at: indexPath, for: sticker)
        case .create:
            return dequeueCreateCell(at: indexPath)
        }
    }
    
    
    func dequeueCreateCell(at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "createCell", for: indexPath) as! createCell
        return cell
        
    }
    
    func dequeueStickerCell(at indexPath: IndexPath, for sticker: MSSticker) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stickerCell", for: indexPath) as! stickerCell
        cell.sticker.sticker = sticker
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Sticker #\(indexPath.row) Chosen")
        let item = stickers[indexPath.row]
        switch item {
        case .create:
            print("create cell tapped")
            delegate?.createImage()
        default:
            return
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/4, height: view.frame.width/4)
    }
    
}
