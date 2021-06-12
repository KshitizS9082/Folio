//
//  ImagePickerManager.swift
//  card2
//
//  Created by Kshitiz Sharma on 25/04/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import Foundation
import UIKit


class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var delete = false
    var deleteFromPage = false
    var resiveView = false
    var pickImageCallback : ((UIImage?, Bool, Bool, Bool) -> ())?;//Image, delete, deleteFromPage, resize View

    override init(){
        super.init()
    }

    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage?, Bool, Bool, Bool) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;

        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive){
            UIAlertAction in
            self.delete=true
            self.pickImageCallback?(nil, self.delete, self.deleteFromPage, self.resiveView)
        }
        let deleteFromPageAction = UIAlertAction(title: "Remove From Page", style: .destructive){
            UIAlertAction in
            self.deleteFromPage=true
            self.pickImageCallback?(nil, self.delete, self.deleteFromPage, self.resiveView)
        }
        let resizeView = UIAlertAction(title: "Resize Card", style: .default){
            UIAlertAction in
            self.resiveView=true
            self.pickImageCallback?(nil, self.delete, self.deleteFromPage, self.resiveView)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }

        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(resizeView)
        alert.addAction(cancelAction)
        alert.addAction(deleteFromPageAction)
        alert.addAction(deleteAction)
        alert.popoverPresentationController?.sourceView = self.viewController!.view
        viewController.present(alert, animated: true, completion: nil)
    }
    func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.viewController!.present(picker, animated: true, completion: nil)
        } else {
//            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
//            alertWarning.show()
            let alertController = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: UIAlertController.Style.alert)

            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            {
                 (result : UIAlertAction) -> Void in
                  print("You pressed OK")
            }
            alertController.addAction(okAction)
            print("You don't have camera. Do something to show notification,TODO is inside ImagePickerView.swift")
            //TODO: Do something about this essential line to show notification in absence fo camera
//            self.present(alertController, animated: true, completion: nil)
        }
    }
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }


    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    //for swift below 4.2
    //func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    //    picker.dismiss(animated: true, completion: nil)
    //    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    //    pickImageCallback?(image)
    //}

    // For Swift 4.2+
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        pickImageCallback?(image, delete, deleteFromPage, resiveView)
    }



    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }

}
