import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
extension ColorResource {

    /// The "Accent1" asset catalog color resource.
    static let accent1 = ColorResource(name: "Accent1", bundle: resourceBundle)

    /// The "Accent2" asset catalog color resource.
    static let accent2 = ColorResource(name: "Accent2", bundle: resourceBundle)

    /// The "AccentColor" asset catalog color resource.
    static let accent = ColorResource(name: "AccentColor", bundle: resourceBundle)

    /// The "Icons" asset catalog color resource.
    static let icons = ColorResource(name: "Icons", bundle: resourceBundle)

}

// MARK: - Image Symbols -

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
extension ImageResource {

    /// The "Ellipse" asset catalog image resource.
    static let ellipse = ImageResource(name: "Ellipse", bundle: resourceBundle)

    /// The "File" asset catalog image resource.
    static let file = ImageResource(name: "File", bundle: resourceBundle)

    #warning("The \"FileImage\" image asset name resolves to the symbol \"file\" which already exists. Try renaming the asset.")

    /// The "FilesImage" asset catalog image resource.
    static let files = ImageResource(name: "FilesImage", bundle: resourceBundle)

    /// The "Loading" asset catalog image resource.
    static let loading = ImageResource(name: "Loading", bundle: resourceBundle)

    /// The "LogoLaunch" asset catalog image resource.
    static let logoLaunch = ImageResource(name: "LogoLaunch", bundle: resourceBundle)

    /// The "PencilImage" asset catalog image resource.
    static let pencil = ImageResource(name: "PencilImage", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// The "Accent1" asset catalog color.
    static var accent1: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .accent1)
#else
        .init()
#endif
    }

    /// The "Accent2" asset catalog color.
    static var accent2: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .accent2)
#else
        .init()
#endif
    }

    /// The "AccentColor" asset catalog color.
    static var accent: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .accent)
#else
        .init()
#endif
    }

    /// The "Icons" asset catalog color.
    static var icons: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .icons)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// The "Accent1" asset catalog color.
    static var accent1: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .accent1)
#else
        .init()
#endif
    }

    /// The "Accent2" asset catalog color.
    static var accent2: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .accent2)
#else
        .init()
#endif
    }

    /// The "AccentColor" asset catalog color.
    static var accent: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .accent)
#else
        .init()
#endif
    }

    /// The "Icons" asset catalog color.
    static var icons: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .icons)
#else
        .init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    /// The "Accent1" asset catalog color.
    static var accent1: SwiftUI.Color { .init(.accent1) }

    /// The "Accent2" asset catalog color.
    static var accent2: SwiftUI.Color { .init(.accent2) }

    /// The "AccentColor" asset catalog color.
    static var accent: SwiftUI.Color { .init(.accent) }

    /// The "Icons" asset catalog color.
    static var icons: SwiftUI.Color { .init(.icons) }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    /// The "Accent1" asset catalog color.
    static var accent1: SwiftUI.Color { .init(.accent1) }

    /// The "Accent2" asset catalog color.
    static var accent2: SwiftUI.Color { .init(.accent2) }

    /// The "AccentColor" asset catalog color.
    static var accent: SwiftUI.Color { .init(.accent) }

    /// The "Icons" asset catalog color.
    static var icons: SwiftUI.Color { .init(.icons) }

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "Ellipse" asset catalog image.
    static var ellipse: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ellipse)
#else
        .init()
#endif
    }

    /// The "File" asset catalog image.
    static var file: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .file)
#else
        .init()
#endif
    }

    /// The "FilesImage" asset catalog image.
    static var files: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .files)
#else
        .init()
#endif
    }

    /// The "Loading" asset catalog image.
    static var loading: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .loading)
#else
        .init()
#endif
    }

    /// The "LogoLaunch" asset catalog image.
    static var logoLaunch: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logoLaunch)
#else
        .init()
#endif
    }

    /// The "PencilImage" asset catalog image.
    static var pencil: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pencil)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "Ellipse" asset catalog image.
    static var ellipse: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ellipse)
#else
        .init()
#endif
    }

    /// The "File" asset catalog image.
    static var file: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .file)
#else
        .init()
#endif
    }

    /// The "FilesImage" asset catalog image.
    static var files: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .files)
#else
        .init()
#endif
    }

    /// The "Loading" asset catalog image.
    static var loading: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .loading)
#else
        .init()
#endif
    }

    /// The "LogoLaunch" asset catalog image.
    static var logoLaunch: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logoLaunch)
#else
        .init()
#endif
    }

    /// The "PencilImage" asset catalog image.
    static var pencil: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pencil)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
@available(watchOS, unavailable)
extension ColorResource {

    private init?(thinnableName: String, bundle: Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    private convenience init?(thinnableResource: ColorResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
@available(watchOS, unavailable)
extension ImageResource {

    private init?(thinnableName: String, bundle: Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

// MARK: - Backwards Deployment Support -

/// A color resource.
struct ColorResource: Hashable {

    /// An asset catalog color resource name.
    fileprivate let name: String

    /// An asset catalog color resource bundle.
    fileprivate let bundle: Bundle

    /// Initialize a `ColorResource` with `name` and `bundle`.
    init(name: String, bundle: Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

/// An image resource.
struct ImageResource: Hashable {

    /// An asset catalog image resource name.
    fileprivate let name: String

    /// An asset catalog image resource bundle.
    fileprivate let bundle: Bundle

    /// Initialize an `ImageResource` with `name` and `bundle`.
    init(name: String, bundle: Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// Initialize a `NSColor` with a color resource.
    convenience init(resource: ColorResource) {
        self.init(named: NSColor.Name(resource.name), bundle: resource.bundle)!
    }

}

protocol _ACResourceInitProtocol {}
extension AppKit.NSImage: _ACResourceInitProtocol {}

@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension _ACResourceInitProtocol {

    /// Initialize a `NSImage` with an image resource.
    init(resource: ImageResource) {
        self = resource.bundle.image(forResource: NSImage.Name(resource.name))! as! Self
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// Initialize a `UIColor` with a color resource.
    convenience init(resource: ColorResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}

@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// Initialize a `UIImage` with an image resource.
    convenience init(resource: ImageResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    /// Initialize a `Color` with a color resource.
    init(_ resource: ColorResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Image {

    /// Initialize an `Image` with an image resource.
    init(_ resource: ImageResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}
#endif