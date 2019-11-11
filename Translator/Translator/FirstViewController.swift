//
//  FirstViewController.swift
//  Translator
//
//  Created by Catherine Goode on 10/11/19.
//  Copyright © 2019 Felix. All rights reserved.
//

import UIKit
import AVFoundation

class FirstViewController: UIViewController, UINavigationControllerDelegate{
    
    
    
    
    
    
    
    let captureSession = AVCaptureSession()
    let previewLayer = AVCaptureVideoPreviewLayer()
    var photoOutput = AVCapturePhotoOutput()
    
    override func viewDidLoad() {
          super.viewDidLoad()
        
        let captureSession = AVCaptureSession()
        
        captureSession.beginConfiguration()
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                  for: .video, position: .unspecified)
        guard
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
            captureSession.canAddInput(videoDeviceInput)
            else { return }
        captureSession.addInput(videoDeviceInput)
        
        
            
        let photoOutput = AVCapturePhotoOutput()
        guard captureSession.canAddOutput(photoOutput) else { return }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
        captureSession.commitConfiguration()
        
        self.previewView.videoPreviewLayer.session = self.captureSession
        
        self.captureSession.startRunning()
        
        

        }
    
    
    @IBAction func takePic(_ Sender: Any) {
          
          
          let photoSettings = AVCapturePhotoSettings()
        
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
          
        self.captureSession.stopRunning()
          
      }
      
      @IBOutlet weak var previewView: PreviewView!
    
    @IBOutlet weak var ImageVieww: UIImageView!
    
    }

func sendToCloud(img: UIImage)
{
    let azure = URL(string: "https://australiaeast.api.cognitive.microsoft.com/vision/v2.1/detect")!
    if let sendImage = img.pngData(){
        var request = URLRequest(url: azure)
    request.httpMethod = "POST"
    request.httpBody = try? JSONSerialization.data(withJSONObject: sendImage, options: [])
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("australiaeast.api.cognitive.microsoft.com", forHTTPHeaderField: "Host")
    request.addValue("604cce289ecc46da92e23e4def42d5f4", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
    let session = URLSession.shared
    let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
        print(response!)
        do {
            let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
            print(json)
        } catch {
            print("error")
        }
    })


    task.resume()
    }
}


extension FirstViewController : AVCapturePhotoCaptureDelegate {
   func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    let imageData = photo.fileDataRepresentation()
        if let data = imageData, let img = UIImage(data: data) {
            print(img)
            ImageVieww.image = img
            
            
            
        }
    }
    }



             
            


            
        

            
            
            
          
        
    



