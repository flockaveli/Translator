//
//  FirstViewController.swift
//  Translator
//
//  Created by Catherine Goode on 10/11/19.
//  Copyright © 2019 Felix. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var ImageVieww: UIImageView!
    
    @IBAction func ImportImage(_ sender: Any) {
        
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerController.SourceType.camera
        
        image.allowsEditing = false
        
        self.present(image, animated: true){
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            ImageVieww.image = image
        }
        else{
            //error message 
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

