//
//  CameraPreview.swift
//  CameraInt
//
//  Created by Khan, Zeynah on 10/02/2026.
//
import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var cameraModel: CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        cameraModel.previewLayer.videoGravity = .resizeAspectFill
        cameraModel.previewLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(cameraModel.previewLayer)
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
