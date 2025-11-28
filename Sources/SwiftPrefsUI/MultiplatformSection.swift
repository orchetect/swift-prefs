//
//  MultiplatformSection.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

/// `Section` SwiftUI view wrapper that incorporates footer content idiomatically for each platform.
///
/// - On macOS, the footer content is combined into the form content.
/// - On iOS, the footer content is attached below the form content.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct MultiplatformSection<Content: View, Footer: View>: View {
    public let header: LocalizedStringKey?
    public let content: () -> Content
    public let footer: () -> Footer
    
    public init(
        _ header: LocalizedStringKey? = nil,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.header = header
        self.content = content
        self.footer = footer
    }
    
    public var body: some View {
        #if os(macOS)
        Section {
            VStack {
                content()
                SectionFooterView {
                    footer()
                }
                .foregroundColor(.secondary)
            }
        } header: {
            if let header {
                Text(header)
            } else {
                EmptyView()
            }
        }
        #else
        Section {
            content()
        } footer: {
            SectionFooterView {
                footer()
            }
        }
        #endif
    }
}
