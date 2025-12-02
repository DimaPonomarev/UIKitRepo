//
//  CameraView.swift
//  EupUiKit
//
//  Created by Артем Соловьев on 28.10.2025.
//

import SwiftUI

public struct CameraView: View {
    
    var returnPhotoFromCamera: (Data) -> Void
    
    public init(returnPhotoFromCamera: @escaping (Data) -> Void) {
        self.returnPhotoFromCamera = returnPhotoFromCamera
    }
    
    public var body: some View {
        VStack {
            CameraRepresentable() { image in
                guard let photoData = image.jpegData(compressionQuality: 1) else { return }
                returnPhotoFromCamera(photoData)
            }
        }
        .ignoresSafeArea()
    }
}
