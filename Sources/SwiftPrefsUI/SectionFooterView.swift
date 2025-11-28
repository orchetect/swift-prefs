//
//  SectionFooterView.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

/// Within a SwiftUI `Form` view, use this to wrap `Section` `footer` contents to give it a standardized layout.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct SectionFooterView<Content: View>: View {
    public let alignment: Alignment
    public let innerAlignment: HorizontalAlignment
    public let textAlignment: TextAlignment
    public let content: () -> Content
    
    public init(
        alignment: Alignment = .leading,
        innerAlignment: HorizontalAlignment = .leading,
        textAlignment: TextAlignment = .leading,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.alignment = alignment
        self.innerAlignment = innerAlignment
        self.textAlignment = textAlignment
        self.content = content
    }
    
    public var body: some View {
        ZStack(alignment: alignment) {
            Color.clear
            VStack(alignment: innerAlignment) {
                content()
                    .multilineTextAlignment(textAlignment)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
