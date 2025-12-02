//
//  EupGalleryPickerScreen.swift
//  EupUiKit
//
//  Created by Артем Соловьев on 22.10.2025.
//

import SwiftUI
import Combine

public enum TypeOfGalleryScreen {
    case defaultScreen
    case cameraOnly
    case filesOnly
}

@available(iOS 16.0, *)
public struct EupGalleryPickerScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.theme) private var theme
    
    @StateObject private var photoCellSelectionController = PhotoCellSelectionController()
    @StateObject private var viewModel = GalleryViewModel()
    @StateObject private var cameraPreview: CameraPreviewSession = CameraPreviewSession()
    
    @State private var photoCellFrames: [Int: CGRect] = [:]
    @State private var currentDetents: PresentationDetent = .medium
    
    private var typeOfGalleryScreen: TypeOfGalleryScreen = .defaultScreen
    private let onConfirm: ([Data]) -> Void
    private let tapOnCamera: () -> Void
    private let tapOnChooseFile: () -> Void
    private let grid = [GridItem(.flexible(), spacing: 4),
                        GridItem(.flexible(), spacing: 4),
                        GridItem(.flexible(), spacing: 4)]
    
    public init(
        onConfirm: @escaping ([Data]) -> Void,
        tapOnCamera: @escaping () -> Void,
        tapOnChooseFile: @escaping () -> Void,
        typeOfGalleryScreen: TypeOfGalleryScreen = .defaultScreen
    ) {
        self.onConfirm = onConfirm
        self.tapOnCamera = tapOnCamera
        self.tapOnChooseFile = tapOnChooseFile
        self.typeOfGalleryScreen = typeOfGalleryScreen
    }
    
    private var tooBarOfGallerySheet: some View {
        HStack {
            EupButton(
                buttonType: .withTextOnly(
                    theme.primaryColor
                ),
                title: "Отмена",
                alignment: .leading,
                action: { dismiss() }
            )
            
            EupButton(
                buttonType: .withTextOnly(
                    theme.primaryColor
                ),
                title: "Подтвердить \(viewModel.selectionCountString)",
                alignment: .trailing,
                isDisable: viewModel.selection.isEmpty || viewModel.isLoading,
                action: {
                    viewModel.confirmSelection { imageData in
                        onConfirm(imageData)
                        dismiss()
                    }
                }
            )
        }
        .padding(.vertical, 12)
    }
    
    private var cameraPreviewButton: some View {
        Button(
            action: {
                tapOnCamera()
            },
            label: {
                CameraLivePreviewView(session: cameraPreview.session)
                    .overlay {
                        ZStack {
                            Color.black.opacity(0.7).ignoresSafeArea()
                            EupText(
                                fontType: .semibold(16),
                                text: "Камера",
                                foregroundColor: theme.onSurfaceWhite
                            )
                        }
                    }
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .frame(height: 125)
        .layoutPriority(1)
    }
    
    private var fileButton: some View {
        Button(
            action: tapOnChooseFile,
            label: {
                Rectangle()
                    .fill(theme.onBackgroundDarkGray)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .frame(
                        minWidth: 127,
                        minHeight: 127
                    )
                    .overlay {
                        HStack {
                            Image(systemName: "paperclip")
                                .tint(theme.onSurfaceWhite)
                            EupText(
                                fontType: .semibold(16),
                                text: "Файлы",
                                foregroundColor: theme.onSurfaceWhite
                            )
                        }
                    }
            }
        )
    }
    
    public var body: some View {
        VStack {
            tooBarOfGallerySheet
            if viewModel.assets.isEmpty {
                VStack(spacing: 12) {
                    if viewModel.isLoading {
                        ProgressView("Загружаем…")
                    } else {
                        EupText(
                            fontType: .medium(14),
                            text: "Нет фотографий или нет доступа"
                        )
                        EupButton(
                            buttonType: .containedPrimaryColor,
                            title: "Обновить доступ",
                            action: {
                                viewModel.requestPermissionAndLoad()
                            }
                        )
                    }
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )
            } else {
                ScrollView {
                    VStack(spacing: 4) {
                        controllButtonsLayout()
                        LazyVGrid(
                            columns: grid,
                            spacing: 4
                        ) {
                            ForEach(
                                viewModel.assets.indices,
                                id: \.self
                            ) { index in
                                PhotoCell(
                                    index: index,
                                    asset: viewModel.assets[index],
                                    selected: photoCellSelectionController.selected.contains(index)
                                ) {
                                    toggleSingle(index)
                                }
                                .disabled(photoCellSelectionController.isDragging)
                            }
                        }
                        .padding([.horizontal], 4)
                        .coordinateSpace(name: "PhotoGrid")
                        .onPreferenceChange(PhotoCellPrefKey.self) { photoCellFrames = $0 }
                        .simultaneousGesture(selectionGesture)
                    }
                }
                .scrollDisabled(photoCellSelectionController.isDragging)
                .animation(
                    .smooth(duration: 0.15),
                    value: cameraPreview.isPrepared
                )
            }
        }
        .navigationBarBackButtonHidden()
        .overlay {
            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.1).ignoresSafeArea()
                    ProgressView().scaleEffect(1.2)
                }
            }
        }
        .onAppear {
            viewModel.requestPermissionAndLoad()
            cameraPreview.prepareIfNeeded()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                cameraPreview.start()
            }
        }
        .animation(
            .smooth(duration: 0.15),
            value: viewModel.selectionCountString
        )
        .interactiveDismissDisabled(photoCellSelectionController.isDragging)
    }
    
    @ViewBuilder
    private func controllButtonsLayout() -> some View {
        HStack(spacing: 4) {
            switch typeOfGalleryScreen {
            case .defaultScreen:
                if cameraPreview.isPrepared {
                    cameraPreviewButton
                }
                fileButton
            case .cameraOnly:
                if cameraPreview.isPrepared {
                    cameraPreviewButton
                }
            case .filesOnly:
                fileButton
            }
        }
        .padding(.horizontal, 4)
    }
    
    private func toggleSingle(_ i: Int) {
        viewModel.toggle(viewModel.assets[i])
        if photoCellSelectionController.selected.contains(i) {
            photoCellSelectionController.selected.remove(i)
        } else {
            photoCellSelectionController.selected.insert(i)
        }
    }
    
    // MARK: - Жест
    private var selectionGesture: some Gesture {
        LongPressGesture(minimumDuration: 0.15)
            .sequenced(before: DragGesture(minimumDistance: 0))
            .onChanged { value in
                switch value {
                case .first(true):
                    break
                case .second(true, let drag):
                    if let p = drag?.location {
                        if photoCellSelectionController.isDragging == false {
                            photoCellSelectionController.startSelect(at: index(at: p))
                        } else if let idx = index(at: p) {
                            photoCellSelectionController.applySelected(index: idx)
                        }
                    }
                default:
                    break
                }
            }
            .onEnded { value in
                photoCellSelectionController.alreadySelectedCell.forEach { i in
                    viewModel.toggle(viewModel.assets[i])
                }
                photoCellSelectionController.endSelect()
            }
    }
    
    private func index(at point: CGPoint) -> Int? {
        photoCellFrames.first(where: { $0.value.contains(point) })?.key
    }
}
