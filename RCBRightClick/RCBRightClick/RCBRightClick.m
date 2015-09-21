//
//  RCBRightClick.m
//  RCBRightClickDemo
//
//  Created by Rob Jonson on 20/08/2015.
//  Copyright © 2015 HobbyistSoftware. All rights reserved.
//

#import "RCBRightClick.h"

#define RCB_Identifier @"com.HobbyistSoftware.RightClick"



@implementation RCBRightClick

+(BOOL)systemCanHandleRCB
{
    NSProcessInfo *info=[NSProcessInfo processInfo];
    if ([info respondsToSelector:@selector(operatingSystemVersion)])
    {
        NSOperatingSystemVersion version=[info operatingSystemVersion];
        if (version.minorVersion>=10)
        {
            return YES;
        }
    }
    
    return NO;
}

+(BOOL)RCBInstalled
{
    NSString *rcbPath=[[NSWorkspace sharedWorkspace] absolutePathForAppBundleWithIdentifier:RCB_Identifier];
    if (rcbPath)
    {
        return YES;
    }
    else
    {
        NSAlert *alert=[NSAlert new];
        [alert setMessageText:@"Please install Right Click Booster..."];
        [alert setInformativeText:@"Right Click Booster is a free application which allows developers to add right-click options to their apps.\n\nPlease click to open it in the Appstore"];
        [alert addButtonWithTitle:@"Ok"];
        [alert addButtonWithTitle:@"Cancel"];

        NSWindow *appWindow=[[NSApplication sharedApplication] mainWindow];
        
        [alert beginSheetModalForWindow:appWindow
                      completionHandler:^(NSModalResponse returnCode) {
                          if (returnCode==NSAlertFirstButtonReturn)
                          {
                              [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"macappstores://itunes.apple.com/us/app/right-click-booster/id970432740?mt=12ign-mpt=uo%3D4affC=QQANAAAACwAtOnMHMWwzdm5mRQVoc1JDQgAAAAA516Dkign-msr=http%3A%2F%2Fhobbyistsoftware.com%2Frcb"]];
                          }
                      }];
        
        return NO;
    }
    
}

+(BOOL)registerExtensionWithName:(NSString*)name scheme:(NSString*)scheme filetypes:(NSArray*)fileExtensions image:(NSImage*)image callbackScheme:(NSString* )callbackScheme
{
    if (![self systemCanHandleRCB])
    {
        return NO;
    }
    
    if (![self RCBInstalled])
    {
        return NO;
    }
    
    
    if (![name length] || ![scheme length])
    {
        NSLog(@"RCB Right Click needs a scheme and name");
        return NO;
    }
    
    NSString *urlString=[NSString stringWithFormat:@"rcbregisterextension://x-callback-url/registerextension?scheme=%@&name=%@",[self escapedString:scheme],[self escapedString:name]];
    
    if ([fileExtensions count])
    {
        NSString *filetypes=[fileExtensions componentsJoinedByString:@","];
        filetypes=[self escapedString:filetypes];
        urlString=[urlString stringByAppendingFormat:@"&filetypes=%@",filetypes];
    }
    
    if (image)
    {
        NSData *imageData=[image TIFFRepresentation];

        NSString *imageDataString=[imageData base64EncodedStringWithOptions:0];
        urlString=[urlString stringByAppendingFormat:@"&image=%@",[self escapedString:imageDataString]];
    }
    
    if (callbackScheme)
    {
        //success will callback to scheme://rcbcallback/success
        NSString *xSuccess=[NSString stringWithFormat:@"%@://rcbcallback/success",callbackScheme];
        urlString=[urlString stringByAppendingFormat:@"?x-success=%@",[self escapedString:xSuccess]];
        
        //cancel will callback to scheme://rcbcallback/cancel
        NSString *xCancel=[NSString stringWithFormat:@"%@://rcbcallback/cancel",callbackScheme];
        urlString=[urlString stringByAppendingFormat:@"?x-cancel=%@",[self escapedString:xCancel]];
        
        //x-error will callback to scheme://rcbcallback/error
        NSString *xError=[NSString stringWithFormat:@"%@://rcbcallback/error",callbackScheme];
        urlString=[urlString stringByAppendingFormat:@"?x-error=%@",[self escapedString:xError]];
    }
    
    //Open URL doesn't seem to open the app - so we do it manually.
    [[NSWorkspace sharedWorkspace]
     launchAppWithBundleIdentifier:RCB_Identifier
     options:NSWorkspaceLaunchWithoutActivation
     additionalEventParamDescriptor:nil
     launchIdentifier:NULL];
    
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:urlString]];
    
    return YES;
}


+(BOOL)registerExtensionWithName:(NSString*)name scheme:(NSString*)scheme
{
    return [self registerExtensionWithName:name
                             scheme:scheme
                          filetypes:nil
                              image:nil
                     callbackScheme:nil];
}


#pragma mark utilities

+(NSString*)escapedString:(NSString*)input
{
    NSString *newString= (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                            (CFStringRef)input,
                                                                            NULL,
                                                                            (CFStringRef)@";/?:@&=+$,", 
                                                                            kCFStringEncodingUTF8
                                                                            ));
    
    return newString;
}

+(NSArray*)pathsFromURL:(NSURL*)url
{
    NSArray *parts=[[url query] componentsSeparatedByString:@"&"];
 
    for (NSString *part in parts) {
        if ([part hasPrefix:@"paths="])
        {
            NSArray *pathParts=[part componentsSeparatedByString:@"="];
            if ([pathParts count] != 2)
            {
                NSLog(@"malformed response");
                return NULL;
            }
            
            NSString *pathString=[pathParts objectAtIndex:1];
            pathString=[pathString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSArray *paths=[pathString componentsSeparatedByString:@","];
            return paths;
        }
    }
    
    return nil;
}

+(NSDictionary*)errorInfoFromURL:(NSURL*)url
{
    NSMutableDictionary *info=[NSMutableDictionary dictionary];
    NSArray *parts=[[url query] componentsSeparatedByString:@"&"];
    
    for (NSString *part in parts) {
        
        NSArray *pathParts=[part componentsSeparatedByString:@"="];
        if ([pathParts count] != 2)
        {
            continue;
        }
        
        NSString *key=[pathParts objectAtIndex:0];
        
        NSString *value=[pathParts objectAtIndex:1];
        value=[value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        
        [info setObject:value forKey:key];
    }
    
    if ([info count])
    {
        return info;
    }
    
    return nil;
}


@end
