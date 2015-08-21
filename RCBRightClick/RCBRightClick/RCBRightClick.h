//
//  RCBRightClick.h
//  RCBRightClickDemo
//
//  Created by Rob Jonson on 20/08/2015.
//  Copyright © 2015 HobbyistSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface RCBRightClick : NSObject

/** RCB only works for OSX 10.10 or higher. */
+(BOOL)systemCanHandleRCB;

+(BOOL)registerExtensionWithName:(NSString* _Nonnull)name scheme:(NSString* _Nonnull)scheme;
/** 
* @param name Display name for the extension
* @param scheme Scheme which will be called by RCB
* @param filetypes Optional case-insensitive list of filetypes which can be handled. Use 'Directory' to support directories. Note that RCB will display and act if any of the selected URLs match this list, so you need to check the returned URLs yourself
* @param image Image to display next to the command in the menu (30*30px)
* @param requestCallback RCB honours the x-callback-url scheme http://x-callback-url.com/specifications/ this parameter provides the scheme registered by your app which should receive callbacks. See the code for comments on the default callback implementation.
*/
+(BOOL)registerExtensionWithName:(NSString* _Nonnull)name scheme:(NSString* _Nonnull)scheme filetypes:(NSArray* _Nullable)fileExtensions image:(NSImage* _Nullable)image callbackScheme:(NSString* _Nullable)callbackScheme;

/** use this to get paths from the callback */
+(NSArray* _Nullable)pathsFromURL:(NSURL* _Nonnull)url;
/** use this to get the error message */
+(NSDictionary* _Nullable)errorInfoFromURL:(NSURL* _Nonnull)url;

@end
