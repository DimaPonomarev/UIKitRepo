//
//  CameraRepresentable.swift
//  EupUiKit
//
//  Created by Артем Соловьев on 22.10.2025.
//

import SwiftUI
import UIKit
import AVFoundation

struct CameraRepresentable: UIViewControllerRepresentable {
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraRepresentable
        init(_ parent: CameraRepresentable) { self.parent = parent }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let img = (info[.editedImage] ?? info[.originalImage]) as? UIImage
            parent.onImage(img ?? UIImage())
            CameraWindowManager.shared.hideCameraWindow()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.onImage(UIImage())
            CameraWindowManager.shared.hideCameraWindow()
        }
    }
    
    var onImage: (UIImage) -> Void
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
