//
//  EupLinkText.swift
//  EupUiKit
//
//  Created by Артём  on 11.03.2025.
//

import SwiftUI

public enum TypeOfLinkText {
    case email
    case phone
    case sms
    case url
}

public struct EupLinkText: View {
    
    @Environment(\.theme) private var theme
    
    private let typeOfLinkText: TypeOfLinkText
    private let linkedText: String
    private var defaultText: String = ""
    private var urlForWebsite: String = ""
    
    private var urlForLink: URL {
        switch typeOfLinkText {
        case .email:
            return URL(string: "mailto:\(linkedText)")!
        case .phone:
            return URL(string: "tel:\(linkedText)")!
        case .sms:
            return URL(string: "sms:\(linkedText)")!
        case .url:
            return URL(string: urlForWebsite)!
        }
    }
    
    private var urlForHiperlink: String {
        "[\(linkedText)](\(urlForWebsite))"
    }
    
    public init(
        typeOfLinkText: TypeOfLinkText,
        linkedText: String,
        defaultText: String = "",
        urlForWebsite: String = ""
    ) {
        self.typeOfLinkText = typeOfLinkText
        self.linkedText = linkedText
        self.urlForWebsite = urlForWebsite
        self.defaultText = defaultText
    }
    
    public var body: some View {
        if typeOfLinkText != .url {
            Link(
                linkedText,
                destination: urlForLink
            )
            .font(theme.fonts.regular(size: 12))
            .foregroundStyle(theme.onSurfaceLightBlue)
        } else {
            Group {
                Text(defaultText + " ")
                + Text(.init(urlForHiperlink))
            }
            .font(theme.fonts.regular(size: 12))
        }
    }
}

#Preview {
    VStack {
        EupLinkText(
            typeOfLinkText: .email,
            linkedText: "tematerbi@mail.ru"
        )
        
        EupLinkText(
            typeOfLinkText: .url,
            linkedText: "это переход на гугл",
            defaultText: "Это текст перед ссылкой на гугл",
            urlForWebsite: "https://google.com"
        )
    }
}
