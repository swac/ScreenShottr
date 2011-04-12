//
//  ScreenShottrAppDelegate.m
//  ScreenShottr
//
//  Created by Ashwin Bhat on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScreenShottrAppDelegate.h"

@implementation ScreenShottrAppDelegate

@synthesize window;
@synthesize connectionInfo;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	start_rng();
}

- (IBAction)createConnection:(id)sender {
    connectionInfo = [[FTPInfo alloc] initWithHost:[host stringValue]
                                          username:[username stringValue]
                                          password:[password stringValue]];
}

- (IBAction)testConnection:(id)sender {
    NSString *inputFilePath;
    
    inputFilePath = @"~/Desktop/file2.png";
    [output setStringValue:[FTPConnection uploadFile:inputFilePath 
                                        toConnection:[self connectionInfo]]];
}

@end
