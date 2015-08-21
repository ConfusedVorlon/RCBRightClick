//
//  AppDelegate.m
//  RCBRightClickDemo
//
//  Created by Rob Jonson on 20/08/2015.
//  Copyright © 2015 HobbyistSoftware. All rights reserved.
//

#import "AppDelegate.h"
#import "RCBRightClick.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

-(id)init
{
    self=[super init];
    if (self)
    {
        [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self
                                                           andSelector:@selector(handleURLEvent:withReplyEvent:)
                                                         forEventClass:kInternetEventClass
                                                            andEventID:kAEGetURL];
    }
    
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)handleURLEvent:(NSAppleEventDescriptor*)event withReplyEvent:(NSAppleEventDescriptor*)replyEvent
{
    NSString *urlString = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
    NSURL *url=[NSURL URLWithString:urlString];
    NSString *scheme = [[url scheme] lowercaseString];
    
    NSLog(@"scheme: %@, string: %@",scheme,urlString);
    
    if ([scheme isEqualToString:@"rcbtest1"])
    {
        [[NSAlert alertWithMessageText:@"Simple extension called"
                         defaultButton:@"Ok"
                       alternateButton:nil
                           otherButton:nil
             informativeTextWithFormat:@"Called for paths:\n%@",[RCBRightClick pathsFromURL:url]] runModal];
    }
    
    if ([scheme isEqualToString:@"rcbtest2"])
    {
        [[NSAlert alertWithMessageText:@"Image Filetype extension called"
                         defaultButton:@"Ok"
                       alternateButton:nil
                           otherButton:nil
             informativeTextWithFormat:@"Called for paths:\n%@",[RCBRightClick pathsFromURL:url]] runModal];
    }
    
    if ([scheme isEqualToString:@"rcbtest3"])
    {
        [[NSAlert alertWithMessageText:@"Simple extension 2 called"
                         defaultButton:@"Ok"
                       alternateButton:nil
                           otherButton:nil
             informativeTextWithFormat:@"Called for paths:\n%@",[RCBRightClick pathsFromURL:url]] runModal];
    }
    
    if ([scheme isEqualToString:@"rcbdemocallback"])
    {
        if ([[url host] isEqualToString:@"rcbcallback"])
        {
            NSLog(@"this is our expected callback");
            
            if ([[url path] isEqualToString:@"/success"])
            {
                NSLog(@"extension registered succesfully");
            }
            else if ([[url path] isEqualToString:@"/cancel"])
            {
                NSLog(@"user cancelled registration");
            }
            else if ([[url path] isEqualToString:@"/error"])
            {
                NSLog(@"error in installation - %@",[RCBRightClick errorInfoFromURL:url]);
            }
        }
    }
    
}

@end
