//
//  CameraLivePreviewView.swift
//  EupUiKit
//
//  Created by Артем Соловьев on 22.10.2025.
//

import AVFoundation
import SwiftUI
import Combine

struct CameraLivePreviewView: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> CameraPreviewHostView {
        CameraPreviewHostView(session: session)
    }
    
    func updateUIView(_ uiView: CameraPreviewHostView, context: Context) {}
}
