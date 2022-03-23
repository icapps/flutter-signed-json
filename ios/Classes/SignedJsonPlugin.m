#import "SignedJsonPlugin.h"
#if __has_include(<signed_json/signed_json-Swift.h>)
#import <signed_json/signed_json-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "signed_json-Swift.h"
#endif

@implementation SignedJsonPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSignedJsonPlugin registerWithRegistrar:registrar];
}
@end
