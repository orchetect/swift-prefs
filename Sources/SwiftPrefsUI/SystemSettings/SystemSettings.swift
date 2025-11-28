//
//  SystemSettings.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

#if !os(macOS)
import UIKit
#endif

public enum SystemSettings {
    #if os(macOS)
    /// Launches System Settings, optionally opening the specified panel.
    public static func launch(panel: Panel? = nil) {
        let command = launchCommand(panel: panel)
        
        // launch
        let p = Process()
        let shellExecutablePath = ProcessInfo.processInfo.environment["SHELL"] ?? "/bin/zsh"
        p.executableURL = URL(fileURLWithPath: shellExecutablePath)
        p.arguments = ["-cl", command]
        do { try p.run() }
        catch { print(error.localizedDescription) }
    }
    
    static func launchCommand(panel: Panel? = nil) -> String {
        // see: https://gist.github.com/rmcdongit/f66ff91e0dad78d4d6346a75ded4b751
        // two methods to launch System Settings:
        // - open -b com.apple.systempreferences /System/Library/PreferencePanes/Security.prefPane
        // - open "x-apple.systempreferences:com.apple.preference.security"
        
        // prefer bundle ID over bundle name where possible, since bundle ID allows sub-panel selection
        if let panel {
            if let bundleID = panel.bundleID {
                "open \"x-apple.systempreferences:\(bundleID)\""
            } else {
                "open -b com.apple.systempreferences \(panel.bundleName)"
            }
        } else {
            #"open "x-apple.systempreferences""#
        }
    }
    
    #elseif !os(watchOS)
    
    @MainActor
    public static func launch() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
    
    #endif
}
