//
//  UIController.m
//  RCBRightClickDemo
//
//  Created by Rob Jonson on 20/08/2015.
//  Copyright © 2015 HobbyistSoftware. All rights reserved.
//

#import "UIController.h"
#import "RCBRightClick.h"

@implementation UIController


- (IBAction)installSimpleExtension:(id)sender {
    
    [RCBRightClick registerExtensionWithName:@"RCB Simple Test"
                                      scheme:@"rcbtest1"];
}

- (IBAction)installFullExtension:(id)sender
{
    [RCBRightClick registerExtensionWithName:@"RCB PNG JPEG Test"
                                      scheme:@"rcbtest2"
                                   filetypes:@[@"png",@"jpg",@"jpeg"]
                                       image:[NSImage imageNamed:@"113-navigation.png"]
                              callbackScheme:nil
     ];
}
- (IBAction)installWithCallback:(id)sender
{
    [RCBRightClick registerExtensionWithName:@"RCB Simple Test 2"
                                      scheme:@"rcbtest3"
                                   filetypes:nil
                                       image:nil
                              callbackScheme:@"rcbdemocallback"
     ];
}



@end
