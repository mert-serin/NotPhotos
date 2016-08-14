//
//  GalleryViewController.swift
//  NotPhotos
//
//  Created by Mert Serin on 29/01/16.
//  Copyright © 2016 Mert Serin. All rights reserved.
//

import UIKit
import Photos
class GalleryViewController:UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet var galleryCollection: UICollectionView!
    var screenH = UIScreen.mainScreen().bounds.height
    var screenW = UIScreen.mainScreen().bounds.width
    
    
    var photoArray = [Photos]()
    
    
    
    override func viewDidLoad() {
        getDirectoryArray()
        
    }
    
    func getDirectoryArray(){
        let fileManager = NSFileManager.defaultManager()
        // We need just to get the documents folder url
        let documentsUrl = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as NSURL
        
        do {
            // if you want to filter the directory contents you can do like this:
            if let directoryUrls = try? NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentsUrl, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants) {
                iterateArray(directoryUrls as Array)
            }
            
        }
    }
    
    @IBAction func addPhoto(sender: AnyObject) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {

        let pObj = Photos()
        pObj.createPhoto(image)
        getDirectoryArray()
        self.dismissViewControllerAnimated(true, completion: nil)
        deletePhoto(editingInfo)
        
    }
    
    func deletePhoto(editingInfo:[String : AnyObject]?){
        let imageUrl = editingInfo![UIImagePickerControllerReferenceURL] as! NSURL
        let imageUrls = [imageUrl]
        //Delete asset
        PHPhotoLibrary.sharedPhotoLibrary().performChanges( {
            let imageAssetToDelete = PHAsset.fetchAssetsWithALAssetURLs(imageUrls, options: nil)
            PHAssetChangeRequest.deleteAssets(imageAssetToDelete)
            },
            completionHandler: { success, error in
                print("bittim")
        })
    }
    
    
    func iterateArray(allPhotos:Array<NSURL>){
        photoArray.removeAll()
        for(var i = 0; i<allPhotos.count; ++i){
            let url = "\(allPhotos[i])".substringFromIndex(16)
            print(url)
            photoArray.append(Photos(url: url))
        }
        galleryCollection.reloadData()
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.galleryCollection.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! PhotoCell
        cell.photo = photoArray[indexPath.row]
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(screenW/3 - 3, screenW/3 - 3)
    }
    
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    
}

extension String
{
    func substringFromIndex(index: Int) -> String
    {
        if (index < 0 || index > self.characters.count)
        {
            print("index \(index) out of bounds")
            return ""
        }
        return self.substringFromIndex(self.startIndex.advancedBy(index))
    }
}


