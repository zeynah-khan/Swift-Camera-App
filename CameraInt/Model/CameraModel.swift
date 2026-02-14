//
//  CameraModel.swift
//  CameraInt
//
//  Created by Khan, Zeynah on 10/02/2026.
//

import SwiftUI
import AVFoundation

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    private let session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    private var cameraQueue: DispatchQueue = DispatchQueue(label: "cameraQueue")
    private var currentPosition: AVCaptureDevice.Position = .back
    @Published var flashMode: AVCaptureDevice.FlashMode = .off
    @Published var capturedImages: [UIImage] = []
    
    var previewLayer: AVCaptureVideoPreviewLayer
    
    override init() {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        super.init()
        setupSession()
    }
    
    private func setupSession() {
        session.beginConfiguration()
        session.sessionPreset = .photo
        
        for input in session.inputs {
            session.removeInput(input)
        }
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: currentPosition),
              let input = try? AVCaptureDeviceInput(device: camera)
        else{
            session.commitConfiguration()
            return
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        session.commitConfiguration()
    }
    
    func startSession() {
        cameraQueue.async {
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }
    
    func stopSession() {
        cameraQueue.async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = flashMode
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        output.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else { return }
        
        DispatchQueue.main.async {
            self.capturedImages.append(image)
        }
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        print("Photo captured and saved")
    }
    
    func switchCamera() {
        cameraQueue.async {
            self.currentPosition = self.currentPosition == .back ? .front : .back
            self.setupSession()
        }
    }
    
    func toggleFlash() {
        switch flashMode {
        case .off:
            flashMode = .on
        case .on:
            flashMode = .auto
        case .auto:
            flashMode = .off
        @unknown default:
            flashMode = .off
        }
    }
}
