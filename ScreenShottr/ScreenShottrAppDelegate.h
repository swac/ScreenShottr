//
//  ScreenShottrAppDelegate.h
//  ScreenShottr
//
//  Created by Ashwin Bhat on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FTPConnection.h"

@interface ScreenShottrAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	
	IBOutlet NSTextField *host;
	IBOutlet NSTextField *username;
	IBOutlet NSSecureTextField *password;
	IBOutlet NSTextField *output;
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction)testConnection:(id)sender;

@end
