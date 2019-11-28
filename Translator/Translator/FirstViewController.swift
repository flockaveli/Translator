//
//  FirstViewController.swift
//  Translator
//
//  Copyright © 2019 Felix. All rights reserved.
//

import UIKit
import AVFoundation


    class FirstViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        @IBOutlet weak var ImageView: UIImageView!
        @IBOutlet weak var ObjectNameText: UILabel!
        @IBOutlet weak var TranslatedText: UILabel!
        
        @IBAction func ImportImage(_ sender: UIButton) {
            self.imagePicker.present(from: sender)
        }
        
        var imagePicker: ImagePicker!

            override func viewDidLoad() {
                super.viewDidLoad()

                self.imagePicker = ImagePicker(presentationController: self, delegate: self)
            }
            
            @IBAction func showImagePicker(_ sender: UIButton) {
            }
        




        
//
//
//    let captureSession = AVCaptureSession()
//    let previewLayer = AVCaptureVideoPreviewLayer()
//    var photoOutput = AVCapturePhotoOutput()
//
        
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
    if let sendImage = img.jpegData(compressionQuality: 1.0){
        var request = URLRequest(url: azure)
    request.httpMethod = "POST"
    request.httpBody = sendImage
    request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
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
        guard let responseString = String(data: data!, encoding: .utf8) else {
            print("Error getting string")
            return
        }
        
        guard let objectsResponse = try? JSONSerialization.jsonObject(with: responseData, options: []) else {
            print("could not extract json")
            return
        }
        
      do {
        
        print("responseString = \(String(describing: responseString))")
        guard let dictionary = objectsResponse as? [String: Any] else {
        print("error at json")
            return}

            guard let nestedObjects = dictionary["objects"] as? [Any] else {
                print("error at top")
                return}
                guard let foundObject = nestedObjects.first else {
                print("error at array")
                    return}
                    guard let objectDetails = foundObject as? [String: Any] else {
                    print("error at objects")
                        return}
        guard let objectname = objectDetails["object"] as? String else {
        print("error at name")
            return}
            do {
                            print(objectname)
                            translate(objectName: objectname)
                            DispatchQueue.main.async {
                                self.ObjectNameText.text = objectname
                                return
                            }
                }
            }
        
        
        
//
//
////        print("The object is: " + objectFound.description)
////
////        guard let objectTitle = objectFound["object"] as? String else {
////          print("Could not get object title from JSON")
////          return
//        }
//        translate(objectName: objectTitle)
//        DispatchQueue.main.async {
//            self.ObjectNameText.text = objectTitle
//        }
      
//      catch  {
//        print("error trying to convert data to JSON")
//        return
//      }
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
         let apiURL = "https://api-apc.cognitive.microsofttranslator.com/translate?api-version=3.0&from=en&to=ko"

    struct encodeText: Codable {
        var text = String()
    }
         let text2Translate = objectName
         var encodeTextSingle = encodeText()
         var toTranslate = [encodeText]()
       let jsonEncoder = JSONEncoder()

         encodeTextSingle.text = text2Translate
         toTranslate.append(encodeTextSingle)
     
    
       guard let jsonToTranslate = try? jsonEncoder.encode(toTranslate) else {
        print("couldnt convert name to json")
        return
    }

         

                
         let url = URL(string: apiURL)
         var request = URLRequest(url: url!)
//         guard let objectfortranslation: Data = objectName.data(using: .utf8)  else {
//        print("couldnt convert string to data")
//        return
//    }

         request.httpMethod = "POST"
         request.addValue(azureKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
    request.addValue(String(describing: jsonToTranslate.count), forHTTPHeaderField: "Content-Length")
         request.addValue(contentType, forHTTPHeaderField: "Content-Type")
    request.addValue("api-apc.cognitive.microsofttranslator.com", forHTTPHeaderField: "Host")
    
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
            
            guard let responseData = data else {
              print("Error: did not receive data")
              return
            }
              guard let responseString = String(data: data!, encoding: .utf8) else {
                  print("Error getting string")
                  return
              }
              print(data, response, error)
            print("responseString = \(String(describing: responseString))")
              guard let translationResponse = try? JSONSerialization.jsonObject(with: responseData, options: []) else {
                  
                  print("could not extract translation json")
                  return
              }
              
            do {
             

                  guard let nestedTranslations = translationResponse as? [Any] else {
                      print("error at top")
                      return}
                      guard let foundObject = nestedTranslations.first as? [String: Any] else {
                      print("error at array")
                          return}
                          guard let translationDetails = foundObject["translations"] as? [Any] else {
                          print("error at translation")
                              return}
                guard let nameinko = translationDetails.first as? [String: Any] else {
                print("error at array")
                    return}
              guard let translatedname = nameinko["text"] as? String else {
              print("error at name")
                  return}
           print("*****")
            DispatchQueue.main.async {
                
            
           self.TranslatedText.text = translatedname
            }
    }
    }
       task.resume()
   }
    }
    

}

extension FirstViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        DispatchQueue.main.async {
        self.ImageView.image = image
        }
        sendToCloud(img: image!)
    }
}

//extension FirstViewController : AVCapturePhotoCaptureDelegate {
//   func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//    let imageData = photo.fileDataRepresentation()
//        if let data = imageData, let img = UIImage(data: data) {
//            sendToCloud(img: img)
//            ImageVieww.image = img
//            ImageVieww.isHidden = false
        
            









             
            

