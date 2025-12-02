//
//  GalleryViewModel.swift
//  EupUiKit
//
//  Created by Артем Соловьев on 22.10.2025.
//

import SwiftUI
import Combine
import Photos

final class GalleryViewModel: ObservableObject {
    
    private let imageManager = PHCachingImageManager()
    
    @Published var assets: [PHAsset] = []
    @Published var selection = Set<String>()
    @Published var isLoading = false
    @Published var goToCamera = false
    
    var selectionCountString: String {
        return selection.count > 0 ? "\(selection.count)" : ""
    }
    
    func requestPermissionAndLoad() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if status == .authorized || status == .limited {
            loadAssets()
        } else {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] s in
                DispatchQueue.main.async {
                    if s == .authorized || s == .limited {
                        self?.loadAssets()
                    }
                }
            }
        }
    }
    
    private func loadAssets() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        
        let fetched = PHAsset.fetchAssets(with: options)
        var list: [PHAsset] = []
        list.reserveCapacity(fetched.count)
        fetched.enumerateObjects { asset, _, _ in list.append(asset) }
        assets = list
    }
    
    func toggle(_ asset: PHAsset) {
        let id = asset.localIdentifier
        if selection.contains(id) { selection.remove(id) } else { selection.insert(id) }
    }
    
    func isSelected(_ asset: PHAsset) -> Bool {
        selection.contains(asset.localIdentifier)
    }
    
    func confirmSelection(completion: @escaping ([Data]) -> Void) {
        let selectedAssets = assets.filter { selection.contains($0.localIdentifier) }
        guard !selectedAssets.isEmpty else {
            completion([])
            return
        }
        
        isLoading = true
        
        // Получаем imageData для выбранных ассетов
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isSynchronous = false
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.version = .current
        
        let group = DispatchGroup()
        var resultBytes: [Data] = []
        resultBytes.reserveCapacity(selectedAssets.count)
        
        for asset in selectedAssets {
            group.enter()
            PHImageManager.default().requestImageDataAndOrientation(for: asset, options: requestOptions) {
                (data, _, _, _) in
                if let data = data {
                    resultBytes.append(data)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.isLoading = false
            completion(resultBytes)
        }
    }
    
    func moveToCamera() {
        goToCamera = true
    }
}
