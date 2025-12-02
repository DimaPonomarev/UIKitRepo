//
//  EupSeachableTextField.swift
//  EupUiKit
//
//  Created by Артём  on 04.03.2025.
//

import SwiftUI

public struct EupSeachableTextField: View {
    
    @Environment(\.theme) private var theme
    
    @Binding private var searchText: String
    private var onChange: ((String) -> Void)
    private var onClearButtonTap: (() -> Void)
    private var onSubmitTap: (() -> Void)
    
    public init(
        searchText: Binding<String>,
        onChange: @escaping (String) -> Void,
        onClearButtonTap: @escaping () -> Void,
        onSubmitTap: @escaping () -> Void
    ) {
        self._searchText = searchText
        self.onChange = onChange
        self.onClearButtonTap = onClearButtonTap
        self.onSubmitTap = onSubmitTap
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            
            TextField("Поиск", text: $searchText)
                .foregroundColor(theme.surfaceDark)
                .onChange(of: searchText) { newValue in
                    onChange(newValue)
                }
                .onSubmit {
                    onSubmitTap()
                }
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                    onClearButtonTap()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .drawingGroup()
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .animation(.smooth(duration: 0.12), value: searchText.isEmpty)
    }
}
