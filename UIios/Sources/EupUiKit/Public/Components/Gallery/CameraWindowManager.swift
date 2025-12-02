//
//  CameraWindowManager.swift
//  EupUiKit
//
//  Created by Артем Соловьев on 24.10.2025.
//

import UIKit
import SwiftUI

public final class CameraWindowManager {
    public static let shared = CameraWindowManager()
    
    public var mainScene: UIWindowScene?
    public var returnPhoto: ((Data) -> Void)?
    
    private var cameraWindow: UIWindow?
    private var cameraControllerForAnimate: UIHostingController<CameraView>?
    private var photoWindow: UIWindow?
    private var photoControllerForAnimate: UIHostingController<PhotoOpenner>?
    
    // MARK: - Gesture setup
    private var panGesture: UIPanGestureRecognizer?
    private var didCrossThreshold = false
    private let dismissThreshold: CGFloat = 0.33
    private let velocityThreshold: CGFloat = 800

    public func showCamera() {
        setupCameraOverlayed()
    }
    
    public func hideCameraWindow() {
        guard let windowScene = mainScene,
              let cameraControllerForAnimate = cameraControllerForAnimate else {
            return
        }
        
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: [.curveEaseIn, .allowUserInteraction]) {
            cameraControllerForAnimate.view.transform = CGAffineTransform(
                translationX: 0,
                y: windowScene.screen.bounds.height * 0.5
            )
            cameraControllerForAnimate.view.alpha = 0.0
        } completion: { _ in
            self.cameraWindow = nil
            self.cameraControllerForAnimate = nil
        }
    }
    
    public func openPhotoView(
        image: UIImage,
        isScreenShot: Bool,
        choosePhoto: @escaping () -> Void
    ) {
        
        guard let windowScene = mainScene else {
            return
        }
        
        let hudWindow = UIWindow(windowScene: windowScene)
        let cameraController = UIHostingController(
            rootView: PhotoOpenner(
                image: image,
                isScreenShot: isScreenShot,
                close: {
                    self.hidePhotoWindow()
                }, choose: choosePhoto
            )
        )
        cameraController.view.backgroundColor = .clear
        hudWindow.rootViewController = cameraController
        hudWindow.isHidden = false
        hudWindow.windowLevel = .statusBar + 10 //
        
        
        let h = windowScene.screen.bounds.height
        cameraController.view.transform = CGAffineTransform(translationX: 0, y: h * 0.45)
        cameraController.view.alpha = 0.0
        
        UIView.animate(withDuration: 0.36,
                       delay: 0,
                       usingSpringWithDamping: 0.88,
                       initialSpringVelocity: 0.8,
                       options: [.curveEaseOut, .allowUserInteraction]) {
            cameraController.view.transform = .identity
            cameraController.view.alpha = 1.0
        }
        
        self.photoWindow = hudWindow
        self.photoControllerForAnimate = cameraController
        
        enableSwipeToDismiss()
    }
    
    private func hidePhotoWindow() {
        guard let windowScene = mainScene,
              let controller = photoControllerForAnimate else { return }

        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: [.curveEaseIn, .allowUserInteraction]) {
            controller.view.transform = CGAffineTransform(
                translationX: 0,
                y: windowScene.screen.bounds.height * 0.5
            )
            controller.view.alpha = 0.0
        } completion: { _ in
            self.finishHidingPreview()
        }
    }
    
    private func setupCameraOverlayed() {
        
        guard let windowScene = mainScene else {
            return
        }
        
        let hudWindow = UIWindow(windowScene: windowScene)
        let cameraController = UIHostingController(
            rootView: CameraView(returnPhotoFromCamera: { photoData in
                self.returnPhoto?(photoData)
            })
        )
        cameraController.view.backgroundColor = .clear
        hudWindow.rootViewController = cameraController
        hudWindow.isHidden = false
        hudWindow.windowLevel = .statusBar + 10 //
        
        
        let h = windowScene.screen.bounds.height
        cameraController.view.transform = CGAffineTransform(translationX: 0, y: h * 0.45)
        cameraController.view.alpha = 0.0
        
        UIView.animate(withDuration: 0.36,
                       delay: 0,
                       usingSpringWithDamping: 0.88,
                       initialSpringVelocity: 0.8,
                       options: [.curveEaseOut, .allowUserInteraction]) {
            cameraController.view.transform = .identity
            cameraController.view.alpha = 1.0
        }
        
        self.cameraWindow = hudWindow
        self.cameraControllerForAnimate = cameraController
    }
    
    private func enableSwipeToDismiss() {
        guard let view = photoControllerForAnimate?.view else { return }
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePreviewPan(_:)))
        pan.cancelsTouchesInView = false
        panGesture = pan
        view.addGestureRecognizer(pan)
    }
    
    @objc private func handlePreviewPan(_ g: UIPanGestureRecognizer) {
        guard
            let windowScene = mainScene,
            let preview = photoControllerForAnimate?.view
        else { return }

        let container = preview.superview ?? preview
        let translationYRaw = g.translation(in: container).y
        let translationY: CGFloat = translationYRaw > 0 ? translationYRaw : translationYRaw * 0.2

        let screenH = windowScene.screen.bounds.height
        let interactiveDistance = screenH * 0.6
        let progress = max(0, min(1, translationY / interactiveDistance))

        switch g.state {
        case .began, .changed:
            preview.transform = CGAffineTransform(translationX: 0, y: translationY)
            preview.alpha = 1 - progress

            if !didCrossThreshold, progress > dismissThreshold {
                let gen = UIImpactFeedbackGenerator(style: .light)
                gen.impactOccurred()
                didCrossThreshold = true
            } else if didCrossThreshold, progress <= dismissThreshold {
                didCrossThreshold = false
            }

        case .ended, .cancelled, .failed:
            let velocityY = g.velocity(in: container).y
            let shouldDismiss = (progress > dismissThreshold) || (velocityY > velocityThreshold)

            if shouldDismiss {
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0,
                    options: [.curveEaseIn, .allowUserInteraction]
                ) {
                    preview.transform = CGAffineTransform(
                        translationX: 0,
                        y: screenH * 0.5
                    )
                    preview.alpha = 0
                } completion: { _ in
                    self.finishHidingPreview()
                }
            } else {
                UIView.animate(
                    withDuration: 0.35,
                    delay: 0,
                    usingSpringWithDamping: 0.85,
                    initialSpringVelocity: 0.0,
                    options: [.allowUserInteraction, .curveEaseOut]
                ) {
                    preview.transform = .identity
                    preview.alpha = 1
                }
            }

            didCrossThreshold = false

        default:
            break
        }
    }
    
    private func finishHidingPreview() {
        self.photoWindow = nil
        self.photoControllerForAnimate = nil
    }
}
