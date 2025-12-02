//
//  CameraPreviewHostView.swift
//  EupUiKit
//
//  Created by Артем Соловьев on 22.10.2025.
//

import AVFoundation
import SwiftUI
import Combine

final class CameraPreviewHostView: UIView {
    let layerPreview: AVCaptureVideoPreviewLayer
    
    init(session: AVCaptureSession) {
        self.layerPreview = AVCaptureVideoPreviewLayer(session: session)
        self.layerPreview.videoGravity = .resizeAspectFill
        super.init(frame: .zero)
        self.layer.addSublayer(layerPreview)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        layerPreview.frame = bounds
        CATransaction.commit()
    }
}
