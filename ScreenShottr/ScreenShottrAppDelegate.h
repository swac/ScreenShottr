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

@interface ScreenShottrAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    
    FTPInfo *connectionInfo;
	
	IBOutlet NSTextField *host;
	IBOutlet NSTextField *username;
	IBOutlet NSSecureTextField *password;
	IBOutlet NSTextField *output;
    
    BOOL shouldObserveDesktop;
	NSDictionary *knownScreenshotsOnDesktop;
	NSString *screenshotLocation;
	NSString *screenshotFilenameSuffix;
}

@property (assign) IBOutlet NSWindow *window;
@property (retain) FTPInfo *connectionInfo;

- (IBAction)createConnection:(id)sender;

- (void)startObservingDesktop;
- (void)stopObservingDesktop;
- (NSDictionary *)screenshotsOnDesktop;
- (NSDictionary *)screenshotsAtPath:(NSString *)dirpath modifiedAfterDate:(NSDate *)lmod;
- (void)checkForScreenshotsAtPath:(NSString *)dirpath;
- (NSDictionary *)findUnprocessedScreenshotsOnDesktop;

@end
