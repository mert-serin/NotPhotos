//
//  PhotoCell.swift
//  NotPhotos
//
//  Created by Mert Serin on 29/01/16.
//  Copyright © 2016 Mert Serin. All rights reserved.
//

import UIKit
import Haneke

class PhotoCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    var photo:Photos?{
        didSet{
         getImage()
        }
    }
    
    
    func getImage(){
        if let url = photo?.url{
            imageView.hnk_setImageFromFile(url)
        }
    }
    
    
}
