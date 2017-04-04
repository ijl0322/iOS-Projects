//
//  CollectionViewCell.swift
//  Bunny Cam
//
//  Created by Isabel  Lee on 07/03/2017.
//  Copyright © 2017 Isabel  Lee. All rights reserved.
//

import UIKit

//This is a custom collectionViewCell to hold the stickers
class CollectionViewCell: UICollectionViewCell {
    
    var stickerImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stickerImage = UIImageView(frame: contentView.frame)
        stickerImage.contentMode = .scaleAspectFit
        stickerImage.clipsToBounds = true
        contentView.addSubview(stickerImage)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

