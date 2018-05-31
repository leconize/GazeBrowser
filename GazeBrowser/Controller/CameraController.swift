//
//  CameraController.swift
//  collect-data-app
//
//  Created by Supphawit Getmark on 15/1/2561 BE.
//  Copyright © 2561 King Mongkut's Institute of Technology Ladkrabang. All rights reserved.
//

import Foundation
import CoreImage
import UIKit
import AVFoundation


protocol CameraControllerDelegate{
    func didCaptureVideoFrame(image: UIImage)
}

class CameraController: NSObject{
    
    let ciContext: CIContext = CIContext(options: nil)
    
    // MARK:- Error
    enum CameraControllerError: Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
    
    // MARK:- Properties
    var captureSession: AVCaptureSession?
    var frontCamera: AVCaptureDevice?
    var frontCameraInput: AVCaptureInput?
    var videoOutput: AVCaptureVideoDataOutput?
    
    var delegate: CameraControllerDelegate?
    
    
    // MARK:- CameraSetup
    func prepare(completionHandler: @escaping (Error?) -> Void ){
        
        func createCaptureSession(){
            self.captureSession = AVCaptureSession()
            self.captureSession?.sessionPreset = .vga640x480
        }
        
        func configureCaptureDevice() throws {
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .front)
            if(session.devices.isEmpty){
                throw CameraControllerError.noCamerasAvailable
            }
            
            for camera in session.devices{
                if( camera.position == .front){
                    self.frontCamera = camera
                }
            }
            
            if(self.frontCamera == nil){
                throw CameraControllerError.noCamerasAvailable
            }
        }
        
        func addCaptureDevice() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }

            
            if let frontCamera = self.frontCamera{
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                
                if (captureSession.canAddInput(self.frontCameraInput!)){
                    captureSession.addInput(self.frontCameraInput!)
                }
                else{ throw CameraControllerError.inputsAreInvalid }
            }
            else { throw CameraControllerError.noCamerasAvailable }
        }
        
        func configureVideoOutput() throws {
            
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            let videoSetting: [String: Any] = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            self.videoOutput = AVCaptureVideoDataOutput()
            videoOutput?.videoSettings = videoSetting
            videoOutput!.setSampleBufferDelegate(self, queue: DispatchQueue(label: "video data buffer"))
            if captureSession.canAddOutput(self.videoOutput!) {
                captureSession.addOutput(self.videoOutput!)
            }
            else{
                throw CameraControllerError.inputsAreInvalid
            }
            self.captureSession?.startRunning()
        }
        
        DispatchQueue(label: "prepare").sync {
            do{
                print("start")
                createCaptureSession()
                try configureCaptureDevice()
                try addCaptureDevice()
                try configureVideoOutput()
                print("success")
            }
            catch{
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                return
            }
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    
    func stopSession() -> Void{
        self.captureSession?.stopRunning()
    }
    
    func startSession() -> Void {
        self.captureSession?.startRunning()
    }
    
    func createVideoPreviewLayer() throws -> AVCaptureVideoPreviewLayer {
        guard let session = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
        
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        return videoPreviewLayer
    }
    
    
    
}

extension CameraController: AVCaptureVideoDataOutputSampleBufferDelegate{
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        DispatchQueue.global(qos: .default).async {
            let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
            var image = CIImage.init(cvImageBuffer: imageBuffer!)
            image = image.oriented(CGImagePropertyOrientation(rawValue: 5)!)
            guard let cgImage  = self.ciContext.createCGImage(image, from: image.extent) else { return }
            
            self.delegate?.didCaptureVideoFrame(image: UIImage(cgImage: cgImage))
        }
    }
    
    
    
}
