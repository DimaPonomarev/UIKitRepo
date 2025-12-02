//
//  Checkbox.swift
//  EupUiKit
//
//  Created by Артём  on 19.02.2025.
//

import SwiftUI

public struct Checkbox: View {
    
    private enum Constants {
        static let frame: CGFloat = 24
        static let circleFrame: CGFloat = 24 / 2
    }
    
    @Environment(\.theme) private var theme
    private var isSelected: Bool
    private var isMultiselect: Bool = false
    private var isError: Bool = false
    private var isDisable: Bool = false
    private var onChecked: (Bool) -> Void
    
    private var isShowSelectedContent: CGFloat {
        isSelected ? 1 : 0
    }
    
    public init(
        isSelected: Bool,
        isMultiselect: Bool = false,
        isError: Bool = false,
        isDisable: Bool = false,
        onChecked: @escaping (Bool) -> Void = { _ in }
    ) {
        self.isSelected = isSelected
        self.isMultiselect = isMultiselect
        self.isError = isError
        self.isDisable = isDisable
        self.onChecked = onChecked
    }
    
    private var rectangleCheckbox: some View {
        VStack {
            Image(systemName: "checkmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
                .opacity(isShowSelectedContent)
        }
        .frame(
            width: Constants.frame,
            height: Constants.frame
        )
        .background(getbackgroundColorForChecked())
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .inset(by: 0.5)
                .stroke(
                    getborderColorForChecked(),
                    lineWidth: 1
                )
        }
    }
    
    private var roundedCheckbox: some View {
        VStack {
            Circle()
                .fill(getbackgroundColorForChecked())
                .padding(6)
                .opacity(isShowSelectedContent)
        }
        .frame(
            width: Constants.frame,
            height: Constants.frame
        )
        .background(isError ? theme.informationRed.opacity(0.1) : theme.onSurfaceWhite)
        .clipShape(Circle())
        .overlay {
            RoundedRectangle(cornerRadius: Constants.circleFrame)
                .inset(by: 0.5)
                .stroke(
                    isError ? theme.informationRed : theme.onSurfaceDarkGray,
                    lineWidth: 1
                )
        }
    }
    
    public var body: some View {
        VStack {
            if isMultiselect {
                rectangleCheckbox
            } else {
                roundedCheckbox
            }
        }
        .opacity(isDisable ? 0.4 : 1)
        .disabled(isDisable)
        .onTapGesture {
            onChecked(!isSelected)
        }
    }
    
    private func getbackgroundColorForChecked() -> Color {
        isSelected ?
        isError ? theme.informationRed : theme.primaryColor
        : isError ? theme.informationRed.opacity(0.1) : theme.onSurfaceWhite
    }
    
    private func getborderColorForChecked() -> Color {
        isSelected ?
        isError ? theme.informationRed : theme.primaryColor
        : isError ? theme.informationRed : theme.onSurfaceDarkGray
    }
}

#Preview {
    Checkbox(
        isSelected: true,
        isMultiselect: true,
        isError: false
    )
}
