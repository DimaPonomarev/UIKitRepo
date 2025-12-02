//
//  CameraPreviewSession.swift
//  EupUiKit
//
//  Created by Артем Соловьев on 22.10.2025.
//

import AVFoundation
import SwiftUI
import Combine

final class CameraPreviewSession: ObservableObject {
    let session = AVCaptureSession()
    
    private let workQueue = DispatchQueue(
        label: "cam.session.queue",
        qos: .userInitiated
    )
    
    @Published private(set) var isPrepared = false
    
    func prepareIfNeeded() {
        guard !session.isRunning && !isPrepared else { return }
        workQueue.async { [weak self] in
            guard let self else { return }
            self.session.beginConfiguration()
            self.session.sessionPreset = .high
            
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                  let input = try? AVCaptureDeviceInput(device: device),
                  self.session.canAddInput(input)
            else {
                DispatchQueue.main.async { self.isPrepared = false }
                self.session.commitConfiguration()
                return
            }
            self.session.addInput(input)
            self.session.commitConfiguration()
            
            DispatchQueue.main.async { self.isPrepared = true }
        }
    }
    
    func start() {
        workQueue.async { [weak self] in
            guard let self, !self.session.isRunning else { return }
            self.session.startRunning()
        }
    }
    
    func stop() {
        workQueue.async { [weak self] in
            guard let self, self.session.isRunning else { return }
            self.session.stopRunning()
        }
    }
}
