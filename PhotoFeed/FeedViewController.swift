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

class FeedViewController:UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var firKey:String!
    
    fileprivate var uploadTask: FIRStorageUploadTask!
    fileprivate var progressBar: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseUtil.instance.ref.child( "images" ).child( firKey ).observe(FIRDataEventType.childAdded, with: feedUpdate )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = firKey.substring(to: firKey.index(firKey.startIndex, offsetBy:8))
    }
    
    fileprivate func feedUpdate( snapshot: FIRDataSnapshot )
    {
        guard let data = snapshot.value as? [String:AnyObject] else { return }
        
        print(snapshot.ref.parent?.key)
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
