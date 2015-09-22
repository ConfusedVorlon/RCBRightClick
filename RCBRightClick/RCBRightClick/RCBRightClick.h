//
//  RCBRightClick.h
//  RCBRightClickDemo
//
//  Created by Rob Jonson on 20/08/2015.
//  Copyright © 2015 HobbyistSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>


/**
 `RCBRightClick` makes it easy for you to register a right-click action through Right Click Booster
 */
@interface RCBRightClick : NSObject


///------------------------------------------------
/// @name Registering your extension
///------------------------------------------------

/**
 Simple convenience registration method.
 If Right Click Booster is not installed, the user will be prompted to download it from the App Store.
 @param name Display name for the extension
 @param scheme Scheme which will be called by RCB
*/
+(BOOL)registerExtensionWithName:(NSString* )name scheme:(NSString* )scheme;

/**
 Full registration method.
 If Right Click Booster is not installed, the user will be prompted to download it from the App Store.
 @param name Display name for the extension
 @param scheme Scheme which will be called by RCB
 @param filetypes (Optional) case-insensitive list of filetypes which can be handled. Use 'Directory' to support directories. Note that RCB will display and act if any of the selected URLs match this list, so you need to check the returned URLs yourself
 @param image (Optional) Image to display next to the command in the menu (30*30px)
 @param requestCallback (Optional) RCB honours the x-callback-url scheme http://x-callback-url.com/specifications/ this parameter provides the scheme registered by your app which should receive callbacks. See the code for comments on the default callback implementation.
*/
+(BOOL)registerExtensionWithName:(NSString* )name scheme:(NSString* )scheme filetypes:(NSArray* )fileExtensions image:(NSImage* )image callbackScheme:(NSString* )callbackScheme;


///------------------------------------------------
/// @name Convenience methods
///------------------------------------------------

/** RCB only works for OSX 10.10 or higher. However, it is safe to call the register... commands in lower versions. They simply no-op.
 */
+(BOOL)systemCanHandleRCB;

/** When your app is called with your callback scheme, this function provides an easy way to extract the paths selected by the user from the URL. */
+(NSArray* )pathsFromURL:(NSURL* )url;

/** If you use an x-callback scheme, and the error callback is made to your app, this provides an easy way to extract the error message. */
+(NSDictionary* )errorInfoFromURL:(NSURL* )url;

@end
