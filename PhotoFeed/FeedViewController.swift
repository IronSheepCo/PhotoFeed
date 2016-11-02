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

class FeedViewController:UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var firKey:String!
    
    fileprivate var uploadTask: FIRStorageUploadTask!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = firKey.substring(to: firKey.index(firKey.startIndex, offsetBy:8))
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
        let data = UIImagePNGRepresentation(image)
        
        let imageId = UUID().uuidString
        
        uploadTask = FirebaseUtil.instance.storage.child("images/\(imageId)").put(data!)
        uploadTask.observe(.progress, handler:uploadProgress )
        uploadTask.observe(.success, handler:uploadDone )
        uploadTask.observe(.failure, handler:uploadError )
        
        picker.dismiss(animated: true){}
    }
    
    fileprivate func uploadProgress( snapshot:FIRStorageTaskSnapshot)
    {
        if let progress = snapshot.progress
        {
            let procent = 100.0 * Float( progress.completedUnitCount )/Float(progress.totalUnitCount);
            print( procent )
        }
    }
    
    fileprivate func uploadDone( snapshot:FIRStorageTaskSnapshot )
    {
        
    }
    
    
    fileprivate func uploadError( snapshot:FIRStorageTaskSnapshot )
    {
        print( snapshot.error ?? "no error" )
    }
}
