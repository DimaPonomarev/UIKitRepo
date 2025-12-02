//
//  GallerySheetShowingModifier.swift
//  EupUiKit
//
//  Created by Артем Соловьев on 22.10.2025.
//

import SwiftUI
import Combine

@available(iOS 16.0, *)
public extension View {
    @ViewBuilder
    func showEupGalleryInSheet(
        isShow: Binding<Bool>,
        typeOfGalleryScreen: TypeOfGalleryScreen = .defaultScreen,
        returnImagesData: @escaping ([Data]) -> Void,
        tapOnCamera: @escaping () -> Void
    ) -> some View {
        modifier(
            GallerySheetShowingModifier(
                isShow: isShow,
                typeOfGalleryScreen: typeOfGalleryScreen,
                returnImagesData: returnImagesData,
                tapOnCamera: tapOnCamera
            )
        )
    }
}

@available(iOS 16.0, *)
public struct GallerySheetShowingModifier: ViewModifier {
    
    @Binding private var isShow: Bool
    @State private var isShowFiles: Bool = false
    @State private var isDone: Bool = false
    private let returnImagesData: ([Data]) -> Void
    private let tapOnCamera: () -> Void
    private var typeOfGalleryScreen: TypeOfGalleryScreen = .defaultScreen
    
    init(
        isShow: Binding<Bool>,
        typeOfGalleryScreen: TypeOfGalleryScreen = .defaultScreen,
        returnImagesData: @escaping ([Data]) -> Void,
        tapOnCamera: @escaping () -> Void
    ) {
        self._isShow = isShow
        self.returnImagesData = returnImagesData
        self.tapOnCamera = tapOnCamera
        self.typeOfGalleryScreen = typeOfGalleryScreen
    }
    
    public func body(content: Content) -> some View {
        content
            .sheet(
                isPresented: $isShow,
                content: {
                    EupGalleryPickerScreen(
                        onConfirm: { imagesData in
                            returnImagesData(imagesData)
                            isDone = true
                        },
                        tapOnCamera: tapOnCamera,
                        tapOnChooseFile: {
                            isShowFiles = true
                            isShow = false
                        },
                        typeOfGalleryScreen: typeOfGalleryScreen
                    )
                    .presentationDragIndicator(.hidden)
                    .onAppear {
                        CameraWindowManager.shared.returnPhoto = { photoData in
                            returnImagesData([photoData])
                            isShow = false
                        }
                    }
                }
            )
            .fileImporter(
                isPresented: $isShowFiles,
                allowedContentTypes: [.item]
            ) { result in
                switch result {
                case .success(let success):
                    do {
                        if success.startAccessingSecurityScopedResource() {
                            let fileData = try Data(contentsOf: success)
                            returnImagesData([fileData])
                            isDone = true
                        }
                    } catch {
                        showSnackFileError()
                    }
                case .failure(let failure):
                    showSnackFileError()
                }
            }
            .onChange(of: isShowFiles) { _ in
                if !isShowFiles && !isDone {
                    isShow = true
                }
            }
    }
    
    private func showSnackFileError() {
        OverlayManager.shared.showSnack(
            withConfig: .init(
                snackType: .error,
                description: "Не удалось добавить файл"
            )
        )
    }
}
