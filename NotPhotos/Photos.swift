//
//  Photos.swift
//  NotPhotos
//
//  Created by Mert Serin on 29/01/16.
//  Copyright © 2016 Mert Serin. All rights reserved.
//

import UIKit
import Photos

struct Photos{
    var url = String()
    
    init(url:String){
        self.url = url
    }
    
    init(){
        
    }
    
    
    func createPhoto(image:UIImage){
        var userDefaults = NSUserDefaults.standardUserDefaults()
        if let id = userDefaults.objectForKey("imageId"){
                var imgId = id as! Int
                saveImage2Disk(imgId, image: image)
                userDefaults.setInteger(++imgId, forKey: "imageId")
        }
        else{
            var id = 0
            saveImage2Disk(id, image: image)
            userDefaults.setInteger(++id, forKey: "imageId")
            
        }
    }
    
    
    func saveImage2Disk(id:Int,image:UIImage){
        print(id)
        let imageData = NSData(data:UIImagePNGRepresentation(image)!)
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        var docs: String = paths[0] as! String
        let fullPath = docs + "/\(id).jpg"
        print(fullPath)
        _ = imageData.writeToFile(fullPath, atomically: false)

    }
    
        
    
}
