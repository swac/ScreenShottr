//
//  ScreenShottrAppDelegate.h
//  ScreenShottr
//
//  Created by Ashwin Bhat on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FTPConnection.h"
#import "FTPInfo.h"
#import "NameGenerator.h"

#define BUFFER_SIZE 1024

@interface ScreenShottrAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    
    FTPInfo *connectionInfo;
	
	IBOutlet NSTextField *host;
	IBOutlet NSTextField *username;
	IBOutlet NSSecureTextField *password;
	IBOutlet NSTextField *output;
}

@property (assign) IBOutlet NSWindow *window;
@property (retain) FTPInfo *connectionInfo;

- (IBAction)testConnection:(id)sender;
- (IBAction)createConnection:(id)sender;

@end
