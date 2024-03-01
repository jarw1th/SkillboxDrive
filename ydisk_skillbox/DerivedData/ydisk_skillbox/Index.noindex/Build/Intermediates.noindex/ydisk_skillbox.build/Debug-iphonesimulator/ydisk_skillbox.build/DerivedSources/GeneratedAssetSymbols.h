#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The resource bundle ID.
static NSString * const ACBundleID AC_SWIFT_PRIVATE = @"ruslanparastaev.ydisk-skillbox";

/// The "Accent1" asset catalog color resource.
static NSString * const ACColorNameAccent1 AC_SWIFT_PRIVATE = @"Accent1";

/// The "Accent2" asset catalog color resource.
static NSString * const ACColorNameAccent2 AC_SWIFT_PRIVATE = @"Accent2";

/// The "AccentColor" asset catalog color resource.
static NSString * const ACColorNameAccentColor AC_SWIFT_PRIVATE = @"AccentColor";

/// The "Icons" asset catalog color resource.
static NSString * const ACColorNameIcons AC_SWIFT_PRIVATE = @"Icons";

/// The "Ellipse" asset catalog image resource.
static NSString * const ACImageNameEllipse AC_SWIFT_PRIVATE = @"Ellipse";

/// The "File" asset catalog image resource.
static NSString * const ACImageNameFile AC_SWIFT_PRIVATE = @"File";

/// The "FileImage" asset catalog image resource.
static NSString * const ACImageNameFileImage AC_SWIFT_PRIVATE = @"FileImage";

/// The "FilesImage" asset catalog image resource.
static NSString * const ACImageNameFilesImage AC_SWIFT_PRIVATE = @"FilesImage";

/// The "Loading" asset catalog image resource.
static NSString * const ACImageNameLoading AC_SWIFT_PRIVATE = @"Loading";

/// The "LogoLaunch" asset catalog image resource.
static NSString * const ACImageNameLogoLaunch AC_SWIFT_PRIVATE = @"LogoLaunch";

/// The "PencilImage" asset catalog image resource.
static NSString * const ACImageNamePencilImage AC_SWIFT_PRIVATE = @"PencilImage";

#undef AC_SWIFT_PRIVATE