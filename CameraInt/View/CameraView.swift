//
//  CameraView.swift
//  CameraInt
//
//  Created by Khan, Zeynah on 10/02/2026.
//

import SwiftUI

struct CameraView: View {
    @StateObject private var cameraModel = CameraModel()
    @State private var showPreview = false
    
    private var flashIcon: String {
        switch cameraModel.flashMode {
        case .off:
            return "bolt.slash"
        case .on:
            return "bolt.fill"
        case .auto:
            return "bolt.badge.a"
        @unknown default:
            return "bolt.slash"
        }
    }
    
    var body: some View {
        ZStack{
            CameraPreview(cameraModel: cameraModel)
                .edgesIgnoringSafeArea(.all)
                .background(Color.pink)
            VStack {
                HStack {
                    Button(action: {
                        cameraModel.toggleFlash()
                    }) {
                        Image(systemName: flashIcon)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                    Button(action: {
                        cameraModel.switchCamera()
                    }) {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .padding()
                Spacer()
                ZStack {
                    // Capture Button (true center)
                    Button(action: {
                        cameraModel.capturePhoto()
                    }) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 70, height: 70)
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    }
                    
                    // Thumbnail (aligned left)
                    HStack {
                        if let image = cameraModel.capturedImages.last {
                            Button {
                                showPreview = true
                            } label: {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        } else {
                            Rectangle()
                                .fill(Color.black.opacity(0.3))
                                .frame(width: 60, height: 60)
                                .cornerRadius(10)
                        }
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            cameraModel.startSession()
        }
        .onDisappear {
            cameraModel.stopSession()
        }
        .fullScreenCover(isPresented: $showPreview) {
            FullScreenPreview(images: cameraModel.capturedImages)
        }
    }
}

#Preview {
    CameraView()
}

