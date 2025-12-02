//
//  PhotoCell.swift
//  EupUiKit
//
//  Created by Артем Соловьев on 22.10.2025.
//

import SwiftUI
import Photos

struct PhotoCellPrefKey: PreferenceKey {
    static var defaultValue: [Int: CGRect] = [:]
    static func reduce(
        value: inout [Int : CGRect],
        nextValue: () -> [Int : CGRect]
    ) {
        value.merge(
            nextValue(),
            uniquingKeysWith: { $1
            }
        )
    }
}

public struct PhotoCell: View {
    
    @Environment(\.theme) private var theme
    
    private var index: Int
    private let asset: PHAsset
    private let selected: Bool
    private let tap: () -> Void
    
    @State private var image: UIImage?
    
    public init(
        index: Int,
        asset: PHAsset,
        selected: Bool,
        tap: @escaping () -> Void
    ) {
        self.asset = asset
        self.selected = selected
        self.tap = tap
        self.index = index
    }
    
    public var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(
                action: {
                    if let image = image {
                        CameraWindowManager.shared.openPhotoView(
                            image: image,
                            isScreenShot: asset.mediaSubtypes.contains(.photoScreenshot),
                            choosePhoto: tap
                        )
                    }
                },
                label: {
                    Rectangle()
                        .foregroundStyle(.thinMaterial)
                        .aspectRatio(
                            1,
                            contentMode: .fit
                        )
                        .overlay {
                            if let image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(
                                        width: 300,
                                        height: 300
                                    )
                            } else {
                                ProgressView()
                                    .scaleEffect(0.8)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .contentShape(Rectangle())
                        .task {
                            let target = CGSize(
                                width: asset.pixelWidth,
                                height: asset.pixelHeight
                            )
                            let options = PHImageRequestOptions()
                            options.deliveryMode = .highQualityFormat
                            options.resizeMode = .exact
                            options.isSynchronous = false
                            PHCachingImageManager.default().requestImage(for: asset,
                                                                         targetSize: target,
                                                                         contentMode: .aspectFill,
                                                                         options: options) { img, _ in
                                self.image = img
                            }
                        }
                }
            )
            
            Button(action: tap) {
                Circle()
                    .strokeBorder(
                        selected ? theme.primaryColor : theme.primaryColor.opacity(0.7),
                        lineWidth: 2
                    )
                    .background(Circle().fill(selected ? theme.primaryColor : theme.primaryColor.opacity(0.35)))
                    .frame(
                        width: 24,
                        height: 24
                    )
                    .overlay {
                        if selected {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(6)
            }
        }
        .overlay(
            content: {
                GeometryReader { gr in
                    Color.clear
                        .preference(
                            key: PhotoCellPrefKey.self,
                            value: [index: gr.frame(in: .named("PhotoGrid"))]
                        )
                }
                .allowsTightening(false)
            }
        )
        .animation(
            .smooth(duration: 0.15),
            value: selected
        )
    }
}
