//
//  DSPhotoEditor.swift
//  Runner
//
//  Created by Darwin Morocho on 4/8/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation
import Flutter

class DSPhotoEditor: NSObject,DSPhotoEditorViewControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    
    let imagePicker = UIImagePickerController()
    
    var rootViewController: FlutterViewController!
    
   init(controller: FlutterViewController) {
        super.init()
        rootViewController = controller
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes =  ["public.image"]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.rootViewController.dismiss(animated: false, completion: nil)
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("GOOD GO TO EDITOR")
            let dsPhotoEditorViewController = DSPhotoEditorViewController(image: pickedImage, toolsToHide:nil)
            dsPhotoEditorViewController!.delegate = self
            
            dsPhotoEditorViewController?.modalPresentationStyle = .fullScreen
            self.rootViewController.present(dsPhotoEditorViewController!, animated: true, completion: nil)
        }
        
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.rootViewController.dismiss(animated: true, completion: nil)
    }
    
    func dsPhotoEditor(_ editor: DSPhotoEditorViewController!, finishedWith image: UIImage!) {
          self.rootViewController.dismiss(animated: true, completion: nil)
    }
    
    func dsPhotoEditorCanceled(_ editor: DSPhotoEditorViewController!) {
          self.rootViewController.dismiss(animated: true, completion: nil)
    }
    
    
    func pick() {
        //imagePicker.sourceType = .camera // UIImagePickerController.SourceType.camera
        imagePicker.sourceType = .photoLibrary
        self.rootViewController.present(imagePicker, animated: true, completion: nil)
    }
    
    
}
