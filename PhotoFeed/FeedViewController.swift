//
//  FeedViewController.swift
//  PhotoFeed
//
//  Created by Mac on 02/11/2016.
//  Copyright © 2016 ironsheep.tech. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase
import UIImage_Resize
import MBProgressHUD
import Toast_Swift
import CHTCollectionViewWaterfallLayout

class FeedViewController:UIViewController, CHTCollectionViewDelegateWaterfallLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource
{
    var firKey:String!
    
    fileprivate var uploadTask: FIRStorageUploadTask!
    fileprivate var progressBar: MBProgressHUD!
    fileprivate var noPhotos:Int = 0
    fileprivate var photoPaths:[String] = []
    fileprivate var photoData:[UIImage?] = []
    
    fileprivate var photoQueue:[String] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //(collectionView.collectionViewLayout as! SelfSizingWaterfallCollectionViewLayout).estimatedItemHeight = 300
        
        collectionView.delegate = self
        
        FirebaseUtil.instance.ref.child( "images" ).child( firKey ).observe(FIRDataEventType.childAdded, with: feedUpdate )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = firKey.substring(to: firKey.index(firKey.startIndex, offsetBy:8))
    }
    
    fileprivate func feedUpdate( snapshot: FIRDataSnapshot )
    {
        guard let _ = snapshot.value as? [String:AnyObject] else { return }
        
        photoPaths.append( snapshot.ref.key )
        
        photoQueue.append( photoPaths.last! )
        
        //if we have something in the queue already
        //return
        if( photoQueue.count > 1 )
        {
            return
        }
        
        getNextPhoto()
    }
    
    open func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAt indexPath: IndexPath!) -> CGSize
    {
        return (photoData[ indexPath.row ]?.size)!
    }
    
    fileprivate func getNextPhoto()
    {
        let imagePath = photoQueue.first!
        
        FirebaseUtil.instance.storage.child("images").child( imagePath ).data(withMaxSize: 2*1024*1024){
            data, error in
            
            defer {
                self.photoQueue.removeFirst()
                
                //something in the queue, get it
                if self.photoQueue.count > 0
                {
                    self.getNextPhoto()
                }
            }
            
            guard let realData = data else { return }
            
            DispatchQueue.main.async{
                self.noPhotos = self.noPhotos + 1
                
                self.photoData.insert(UIImage(data:realData), at: 0)
                
                self.collectionView.insertItems(at: [IndexPath(row: 0, section: 0)] )
            }
        }
    }
    
    //MARK: - UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return noPhotos
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellViewId", for: indexPath ) as! DataCellView
        
        guard let image = photoData[ indexPath.row ] else { return cell }
        
        cell.imageView.image = image
        
        return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    @IBAction func addPhoto(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add photo to feed", message: "", preferredStyle: .actionSheet )
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default){ action in self.showPicker(.camera)}
        let galleryAction = UIAlertAction(title: "Photo", style: .default){ action in self.showPicker(.photoLibrary)}
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){action in }
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        
        present( alert, animated:true )
    }
    
    //MARK: - UIImagePicker
    fileprivate func showPicker(_ type: UIImagePickerControllerSourceType )
    {
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = type
        imagePicker.delegate = self
        
        present( imagePicker, animated:true )
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        let image = info[ UIImagePickerControllerOriginalImage ] as! UIImage
        
        let resizedImage = image.resizedImageToFit(in: CGSize(width:500, height:500), scaleIfSmaller: true)
        
        let data = UIImagePNGRepresentation(resizedImage!)
        
        let imageId = UUID().uuidString
        
        uploadTask = FirebaseUtil.instance.storage.child("images/\(imageId)").put(data!)
        uploadTask.observe(.progress, handler:uploadProgress )
        uploadTask.observe(.success, handler:uploadDone )
        uploadTask.observe(.failure, handler:uploadError )
        
        progressBar = MBProgressHUD.showAdded(to: view, animated: true)
        progressBar.mode = .determinateHorizontalBar
        progressBar.label.text = "Uploading image"
        
        //add entry for current feed
        FirebaseUtil.instance.ref.child("images").child( firKey ).child( imageId ).setValue( [ "user":UserSettings.ID, "created_at": String(Int(Date().timeIntervalSince1970)) ] )
        
        picker.dismiss(animated: true){}
    }
    
    //MARK: - Upload handlers
    
    fileprivate func uploadProgress( snapshot:FIRStorageTaskSnapshot)
    {
        if let progress = snapshot.progress
        {
            let procent = 100.0 * Float( progress.completedUnitCount )/Float(progress.totalUnitCount);
            
            progressBar.progress = procent
        }
    }
    
    fileprivate func uploadDone( snapshot:FIRStorageTaskSnapshot )
    {
        progressBar.hide( animated:true )
    }
    
    
    fileprivate func uploadError( snapshot:FIRStorageTaskSnapshot )
    {
        print( snapshot.error ?? "no error" )
    }
}
