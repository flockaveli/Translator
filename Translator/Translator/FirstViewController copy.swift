//
//  FirstViewController.swift
//  Translator
//
//  Copyright © 2019 Felix. All rights reserved.
//

import UIKit
import AVFoundation


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
                return sendToCloud(img: image)
            }
            else{
                //error message
            }
        }
    
    
    
    
//
//
//    let captureSession = AVCaptureSession()
//    let previewLayer = AVCaptureVideoPreviewLayer()
//    var photoOutput = AVCapturePhotoOutput()
//
    override func viewDidLoad() {
          super.viewDidLoad()
        }
        
//        let captureSession = AVCaptureSession()
//
//        captureSession.beginConfiguration()
//        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
//                                                  for: .video, position: .unspecified)
//
//        //NOTE: AVFoundation camera functions cannot work on simulator. Testing must use an iphone
//        guard
//            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
//            captureSession.canAddInput(videoDeviceInput)
//            else { return }
//        captureSession.addInput(videoDeviceInput)
//
//
//
//        let photoOutput = AVCapturePhotoOutput()
//        guard captureSession.canAddOutput(photoOutput) else { return }
//        captureSession.sessionPreset = .photo
//        captureSession.addOutput(photoOutput)
//        captureSession.commitConfiguration()
//
//        self.previewView.videoPreviewLayer.session = self.captureSession
//
//        self.captureSession.startRunning()
//
//
//
//        }
//
//
//    @IBAction func takePic(_ Sender: Any) {
//
//
//          let photoSettings = AVCapturePhotoSettings()
//
//        photoOutput.capturePhoto(with: photoSettings, delegate: self)
//
//        self.captureSession.stopRunning()
//
//      }
//
//      @IBOutlet weak var previewView: PreviewView!
//
//    @IBOutlet weak var ImageVieww: UIImageView!
    
    
    

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
    let APIsession = URLSession.shared
    let task = APIsession.dataTask(with: request) {
      (data, response, error) in
      // check for any errors
      guard error == nil else {
        print("error calling GET")
        print(error!)
        return
      }
      // make sure we got data
      guard let responseData = data else {
        print("Error: did not receive data")
        return
      }
      // parse the result as JSON, since that's what the API provides
      do {
        guard let objectFound = try JSONSerialization.jsonObject(with: responseData, options: [])
          as? [String: Any] else {
          print("error trying to convert data to JSON")
          return
        }
       
        print("The object is: " + objectFound.description)
        
        guard let objectTitle = objectFound["object"] as? String else {
          print("Could not get object title from JSON")
          return
        }
        translate(objectName: objectTitle)
        DispatchQueue.main.async {
            self.ObjectNameText.text = objectTitle
        }
      } catch  {
        print("error trying to convert data to JSON")
        return
      }
        }
    
    
    task.resume()
    }
    
    struct TranslatedStrings: Codable {
        var text: String
        var to: String
    }


func translate(objectName: String){
    
    
         let azureKey = "3d4ca283af2148b485cfbad0f812f453"
         
         let contentType = "application/json"
         let host = "https://api.cognitive.microsofttranslator.com/translate?api-version=3.0"
         let apiURL = "https://dev.microsofttranslator.com/translate?api-version=3.0&from=en&to=ko"
         
    struct encodeText: Codable {
        var text = String()
    }
     
         let text2Translate = objectName
         var encodeTextSingle = encodeText()
         var toTranslate = [encodeText]()
           
         encodeTextSingle.text = text2Translate
         toTranslate.append(encodeTextSingle)
    
    

         let jsonToTranslate = try? JSONSerialization.data(withJSONObject: toTranslate, options: [])
                
                
         let url = URL(string: apiURL)
         var request = URLRequest(url: url!)

         request.httpMethod = "POST"
         request.addValue(azureKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
         request.addValue(contentType, forHTTPHeaderField: "Content-Type")
         request.addValue(host, forHTTPHeaderField: "Host")
         request.httpBody = jsonToTranslate
         
         let config = URLSessionConfiguration.default
         let session =  URLSession(configuration: config)
         
         let task = session.dataTask(with: request) { (data, response, error) in
             
   if error != nil {
               print("this is the error ", error!)
               
               let alert = UIAlertController(title: "Could not connect to service", message: "Please check your network connection and try again", preferredStyle: .actionSheet)
               
               alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
               
               self.present(alert, animated: true)
               
           }
           print("*****")
           self.parseJson(jsonData: data!)
    }
       task.resume()
   }
    }
    
    func parseJson(jsonData: Data) {
    
    //*****TRANSLATION RETURNED DATA*****
    struct ReturnedJson: Codable {
        var translations: [TranslatedStrings]
    }
    struct TranslatedStrings: Codable {
        var text: String
        var to: String
    }
    
    let jsonDecoder = JSONDecoder()
    let langTranslations = try? jsonDecoder.decode(Array<ReturnedJson>.self, from: jsonData)
    let numberOfTranslations = langTranslations!.count - 1
    print(langTranslations!.count)
    
    //Put response on main thread to update UI
    DispatchQueue.main.async {
        self.TranslatedText.text = langTranslations![0].translations[numberOfTranslations].text
    }
}
    @IBOutlet weak var ObjectNameText: UILabel!
    @IBOutlet weak var TranslatedText: UILabel!
}

//extension FirstViewController : AVCapturePhotoCaptureDelegate {
//   func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//    let imageData = photo.fileDataRepresentation()
//        if let data = imageData, let img = UIImage(data: data) {
//            sendToCloud(img: img)
//            ImageVieww.image = img
//            ImageVieww.isHidden = false
        
            
            








             
            

