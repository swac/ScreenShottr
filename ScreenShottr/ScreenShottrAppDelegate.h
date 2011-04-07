//
//  ScreenShottrAppDelegate.h
//  ScreenShottr
//
//  Created by Ashwin Bhat on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ScreenShottrAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
