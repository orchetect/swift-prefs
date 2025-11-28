//
//  SystemSettings Panel.swift
//  swift-prefs • https://github.com/orchetect/swift-prefs
//  © 2025 Steffan Andrews • Licensed under MIT License
//

extension SystemSettings {
    // TODO: This list is not exhaustive, and will change over time with each macOS release.
    public enum Panel: Equatable, Hashable, Sendable {
        /// Users & Groups (aka User Accounts)
        case usersAndGroups
        case appearance
        case appleID
        case battery
        case bluetooth
        case classKit // School / Education?
        case classroomSettings
        case dateAndTime
        case wallpaperOrLegacyDesktopSettings
        case digitalHubCDsAndDVDs
        case displays
        case dock
        
        @available(*, deprecated, message: "Has no effect on macOS 15.")
        case energySaver
        
        @available(*, deprecated, message: "Has no effect on macOS 15.")
        case energySaverPref
        
        /// Mission Control (aka Exposé).
        @available(*, deprecated, message: "Panel missing on newer macOS versions.")
        case missionControlOrLegacyExpose
        
        case extensions
        case familySharing
        case internetAccounts
        case keyboard
        case localization
        case mouse
        case network
        case notifications
        
        @available(*, deprecated, message: "Has no effect on macOS 15. Run Passwords.app instead.")
        case passwords
        
        case printAndFax
        case printAndScan
        case profiles
        case screenTime
        case privacyAndSecurity(_ section: SystemSettings.PrivacyPanel? = nil)
        case sharing(_ section: SystemSettings.SharingPanel? = nil)
        case softwareUpdate
        case sound
        case appleIntelligenceAndSiriOrLegacySpeech
        case spotlight
        case startupDisk
        case timeMachine
        case touchID
        case trackpad
        case accessibility(_ section: SystemSettings.AccessibilityPanel? = nil)
        case wallet
        
        /// Name of bundle located within `/System/Library/PreferencePanes`.
        public var bundleName: String {
            switch self {
            case .usersAndGroups: "Accounts.prefPane"
            case .appearance: "Appearance.prefPane"
            case .appleID: "AppleIDPrefPane.prefPane"
            case .battery: "Battery.prefPane"
            case .bluetooth: "Bluetooth.prefPane"
            case .classKit: "ClassKitPreferencePane.prefPane"
            case .classroomSettings: "ClassroomSettings.prefPane"
            case .dateAndTime: "DateAndTime.prefPane"
            case .wallpaperOrLegacyDesktopSettings: "DesktopScreenEffectsPref.prefPane"
            case .digitalHubCDsAndDVDs: "DigiHubDiscs.prefPane"
            case .displays: "Displays.prefPane"
            case .dock: "Dock.prefPane"
            case .energySaver: "EnergySaver.prefPane"
            case .energySaverPref: "EnergySaverPref.prefPane"
            case .missionControlOrLegacyExpose: "Expose.prefPane"
            case .extensions: "Extensions.prefPane"
            case .familySharing: "FamilySharingPrefPane.prefPane"
            case .internetAccounts: "InternetAccounts.prefPane"
            case .keyboard: "Keyboard.prefPane"
            case .localization: "Localization.prefPane"
            case .mouse: "Mouse.prefPane"
            case .network: "Network.prefPane"
            case .notifications: "Notifications.prefPane"
            case .passwords: "Passwords.prefPane"
            case .printAndFax: "PrintAndFax.prefPane"
            case .printAndScan: "PrintAndScan.prefPane"
            case .profiles: "Profiles.prefPane"
            case .screenTime: "ScreenTime.prefPane"
            case .privacyAndSecurity: "Security.prefPane"
            case .sharing: "SharingPref.prefPane"
            case .softwareUpdate: "SoftwareUpdate.prefPane"
            case .sound: "Sound.prefPane"
            case .appleIntelligenceAndSiriOrLegacySpeech: "Speech.prefPane"
            case .spotlight: "Spotlight.prefPane"
            case .startupDisk: "StartupDisk.prefPane"
            case .timeMachine: "TimeMachine.prefPane"
            case .touchID: "TouchID.prefPane"
            case .trackpad: "Trackpad.prefPane"
            case .accessibility: "UniversalAccessPref.prefPane"
            case .wallet: "Wallet.prefPane"
            }
        }
        
        public var bundleID: String? {
            switch self {
            case .usersAndGroups: nil
            case .appearance: nil
            case .appleID: nil
            case .battery: "com.apple.preference.battery"
            case .bluetooth: nil
            case .classKit: nil
            case .classroomSettings: nil
            case .dateAndTime: nil
            case .wallpaperOrLegacyDesktopSettings: nil
            case .digitalHubCDsAndDVDs: nil
            case .displays: nil
            case .dock: nil
            case .energySaver: nil
            case .energySaverPref: nil
            case .missionControlOrLegacyExpose: nil
            case .extensions: nil
            case .familySharing: nil
            case .internetAccounts: nil
            case .keyboard: nil
            case .localization: nil
            case .mouse: nil
            case .network: nil
            case .notifications: "com.apple.preference.notifications"
            case .passwords: nil
            case .printAndFax: nil
            case .printAndScan: nil
            case .profiles: nil
            case .screenTime: "com.apple.preference.screentime"
            case let .privacyAndSecurity(section):
                "com.apple.preference.security\(section != nil && section!.identifier != nil ? "?\(section!.identifier!)" : "")"
            case let .sharing(section):
                "com.apple.preferences.sharing\(section != nil ? "?\(section!.identifier)" : "")"
            case .softwareUpdate: nil
            case .sound: nil
            case .appleIntelligenceAndSiriOrLegacySpeech: "com.apple.preference.speech"
            case .spotlight: nil
            case .startupDisk: nil
            case .timeMachine: nil
            case .touchID: nil
            case .trackpad: nil
            case let .accessibility(section):
                "com.apple.preference.universalaccess\(section != nil ? "?\(section!.identifier)" : "")"
            case .wallet: nil
            }
        }
    }
}

extension SystemSettings {
    public enum AccessibilityPanel: Equatable, Hashable, Sendable {
        case display
        case zoom
        case voiceOver
        case descriptions
        case captions
        case audio
        case keyboard
        case mouseAndTrackpad
        case switchControl
        case dictation
        
        /// Accessibility panel section identifier.
        ///
        /// Example usage: `com.apple.preference.universalaccess?Seeing_Zoom`
        public var identifier: String {
            switch self {
            case .display: "Seeing_Display"
            case .zoom: "Seeing_Zoom"
            case .voiceOver: "Seeing_VoiceOver"
            case .descriptions: "Media_Descriptions"
            case .captions: "Captioning"
            case .audio: "Hearing"
            case .keyboard: "Keyboard"
            case .mouseAndTrackpad: "Mouse"
            case .switchControl: "Switch"
            case .dictation: "SpeakableItems"
            }
        }
    }
}

extension SystemSettings {
    public enum PrivacyPanel: Equatable, Hashable, Sendable {
        case general
        case advanced
        case fileVault
        case firewall
        case privacyMain // TODO: ?
        case locationServices
        case contacts
        case calendars
        case reminders
        case photos
        case camera
        case microphone
        case speechRecognition
        case accessibility
        case fullDiskAccess
        case automation
        case analyticsAndImprovements
        case advertising
        case inputMonitoring
        case filesAndFolders
        case screenRecording
        
        /// Privacy panel section identifier.
        ///
        /// Example usage: `com.apple.preference.security?General`
        public var identifier: String? {
            switch self {
            case .general: "General"
            case .advanced: "Advanced"
            case .fileVault: "FDE"
            case .firewall: "Firewall"
            case .privacyMain: "Privacy"
            case .locationServices: "Privacy_LocationServices"
            case .contacts: "Privacy_Contacts"
            case .calendars: "Privacy_Calendars"
            case .reminders: "Privacy_Reminders"
            case .photos: "Privacy_Photos"
            case .camera: "Privacy_Camera"
            case .microphone: "Privacy_Microphone"
            case .speechRecognition: "Privacy_SpeechRecognition"
            case .accessibility: "Privacy_Accessibility"
            case .fullDiskAccess: "Privacy_AllFiles"
            case .automation: "Privacy_Automation"
            case .analyticsAndImprovements: "Privacy_Diagnostics"
            case .advertising: "Privacy_Advertising"
            case .inputMonitoring: nil
            case .filesAndFolders: nil
            case .screenRecording: nil
            }
        }
    }
}

extension SystemSettings {
    public enum SharingPanel: Equatable, Hashable, Sendable {
        case screenSharing
        case fileSharing
        case printerSharing
        case remoteLogin
        case remoteManagement
        case remoteAppleEvents
        case internetSharing
        case bluetoothSharing
        
        /// Sharing panel section identifier.
        ///
        /// Example usage: `com.apple.preference.sharing?Internet`
        public var identifier: String {
            switch self {
            case .screenSharing: "Services_ScreenSharing"
            case .fileSharing: "Services_PersonalFileSharing"
            case .printerSharing: "Services_PrinterSharing"
            case .remoteLogin: "Services_RemoteLogin"
            case .remoteManagement: "Services_ARDService"
            case .remoteAppleEvents: "Services_RemoteAppleEvent"
            case .internetSharing: "Internet"
            case .bluetoothSharing: "Services_BluetoothSharing"
            }
        }
    }
}
