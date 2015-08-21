# RCBRightClick

Simple finder integration for Mac OS.
Mavericks brought the finder extension, so developers can finally integrate right-click actions into the finder.
It did not bring easy integration though - finder extensions are thoroughly painful to build.

RCBRightClick provides easy finder integration. You simply register the name of your action, the scheme which should be called with details of the selected files and (optionally) the filetypes you are interested in.

== Preliminary - This is not live yet.


Right Click Booster is a free app on the Mac App Store that allows users to run scripts by right clicking on files in the finder.

It uses a finder extension to do this - which is thoroughly painful.

It now offers an interface so that you can add a right click action directly to your app, without the pain of building a full finder extension, and without needing to deliver your app through the app store.

**Installation**

Install with cocoapods

    pod 'RCBRightClick'

Your extension should be installed as a result of user action (like clicking on a 'yes please do this' button).

    [RCBRightClick registerExtensionWithName:@"Do something in my app"
                                      scheme:@"myscheme"];

The user will be prompted to install Right Click Booster if it is not already installed.

Once Right Click Booster is installed, they will be asked to confirm that they want this extension installed.

When the user clicks on a link, your app is called via the scheme you registered.

![Image of simple item](https://raw.githubusercontent.com/ConfusedVorlon/RCBRightClick/master/images/simpleItem.png)

To get the callback, you need to add the following in your App Delegate:

1) In the init method, register your url handler

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

now you can handle the callback

    - (void)handleURLEvent:(NSAppleEventDescriptor*)event withReplyEvent:(NSAppleEventDescriptor*)replyEvent
    {
        NSString *urlString = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
        NSURL *url=[NSURL URLWithString:urlString];
        NSString *scheme = [[url scheme] lowercaseString];
        
        NSLog(@"scheme: %@, string: %@",scheme,urlString);
        
        if ([scheme isEqualToString:@"myscheme"])
        {
            [[NSAlert alertWithMessageText:@"My extension called"
                             defaultButton:@"Ok"
                           alternateButton:nil
                               otherButton:nil
                 informativeTextWithFormat:@"Called for paths:\n%@",[RCBRightClick pathsFromURL:url]] runModal];
        }
    }

finally, you need to add your scheme as a URL Type in the info tab of your project.

![Image of URL scheme](https://raw.githubusercontent.com/ConfusedVorlon/RCBRightClick/master/images/scheme.png)

**Advanced**


You can register more info for your extension...

    [RCBRightClick registerExtensionWithName:@"RCB PNG JPEG Test"
                                      scheme:@"rcbtest2"
                                   filetypes:@[@"png",@"jpg",@"jpeg"]
                                       image:[NSImage imageNamed:@"113-navigation.png"]
                              callbackScheme:@"rcbdemocallback"
     ];

filetypes is a comma delimited list of types that should trigger your extension. You can use the @"directory" if you would like to receive directories

image allows you to set an image that will appear in the right click options by your action

callback scheme allows you to register a callback so that RCB will return information about whether the extension was succesfully installed. It follows the [x-callback-url specification][1]. See the demo project for info on how to handle the callback.


  [1]: http://x-callback-url.com/
