//
//  FullScreenPreview.swift
//  CameraInt
//
//  Created by Zeynah Khan on 14/02/2026.
//

import SwiftUI

import SwiftUI

struct FullScreenPreview: View {
    let images: [UIImage]
    @Environment(\.dismiss) private var dismiss
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var selectedIndex: Int = 0

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
                Spacer()

                // Main Image
                TabView(selection: $selectedIndex) {
                    ForEach(images.indices, id: \.self) { index in
                        ZoomableScrollView(image: images[index])
                            .ignoresSafeArea()
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                Spacer()

                // Thumbnail Strip
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(images.indices, id: \.self) { index in
                            Image(uiImage: images[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(index == selectedIndex ? Color.white : Color.clear, lineWidth: 2)
                                )
                                .onTapGesture {
                                    selectedIndex = index
                                }
                        }
                    }
                    .padding()
                }
            }

            // Close Button
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                Spacer()
            }
        }
    }
}
