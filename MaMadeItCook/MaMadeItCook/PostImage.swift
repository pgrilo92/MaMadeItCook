//
//  postImage.swift
//  MaMadeIt
//
//  Created by Joaquim Patrick Ramos Grilo on 2015-12-28.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse


class PostImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var activityIndicator = UIActivityIndicatorView()
    
    func displayAlert(_ title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction((UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
            self.dismiss(animated: true, completion: nil)
            
        })))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    
    
    @IBOutlet var imageToPost: UIImageView!
    
    @IBAction func chooseImage(_ sender: AnyObject) {
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismiss(animated: true, completion:nil)
        
        imageToPost.image = image
        
        photoSelected = true
        
    }
    
    @IBOutlet var foodName: UITextField!
    @IBOutlet var message: UITextField!
    @IBOutlet var ingredients: UITextField!
    var photoSelected:Bool = false
    
    @IBAction func postImage(_ sender: AnyObject) {
            
            
            activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
            activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            let post = PFObject(className: "Post")
            
            post["message"] = message.text
            post["foodName"] = foodName.text
            post["ingredients"] = ingredients.text
            
            post["userId"] = PFUser.current()!.objectId!
        
            let imageData = (imageToPost.image)!.lowestQualityJPEGNSData
            
            let imageFile = PFFile(name: "image.png", data: imageData)
            
            post["imageFile"] = imageFile
            
            post.saveInBackground{(success, error) -> Void in
                
                self.activityIndicator.stopAnimating()
                
                UIApplication.shared.endIgnoringInteractionEvents()
                
                if error == nil {
                    
                    self.displayAlert("Image Posted!", message: "Your image has been posted successfully")
                    
                    self.imageToPost.image = UIImage(named: "")
                    
                    self.message.text = ""
                    self.foodName.text = ""
                    self.ingredients.text = ""
                    
                } else {
                    
                    self.displayAlert("Could not post image", message: "Please try again later")
                    
                }
                
            }
            
            }
    

   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoSelected = false
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }}

extension UIImage {
    var uncompressedPNGData: Data      { return UIImagePNGRepresentation(self)!        }
    var highestQualityJPEGNSData: Data { return UIImageJPEGRepresentation(self, 1.0)!  }
    var highQualityJPEGNSData: Data    { return UIImageJPEGRepresentation(self, 0.75)! }
    var mediumQualityJPEGNSData: Data  { return UIImageJPEGRepresentation(self, 0.5)!  }
    var lowQualityJPEGNSData: Data     { return UIImageJPEGRepresentation(self, 0.25)! }
    var lowestQualityJPEGNSData:Data   { return UIImageJPEGRepresentation(self, 0.0)!  }
}
