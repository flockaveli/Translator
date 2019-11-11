//
//  PhotoCaptureDelegate.swift
//  Translator
//
//  Created by Catherine Goode on 11/11/19.
//  Copyright © 2019 Felix. All rights reserved.
//

import Foundation

extension ViewController : AVCapturePhotoCaptureDelegate {
func capture(_ captureOutput: AVCapturePhotoOutput,
didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?,
previewPhotoSampleBuffer: CMSampleBuffer?,
resolvedSettings: AVCaptureResolvedPhotoSettings,
bracketSettings: AVCaptureBracketedStillImageSettings?,
error: Error?) {
// get captured image
}
}
