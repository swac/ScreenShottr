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
    screenshotLocation = [[NSString stringWithString:@"~/Desktop"] retain];
    screenshotFilenameSuffix = [[NSString stringWithString:@".png"] retain];
    knownScreenshotsOnDesktop = [[self screenshotsOnDesktop] retain];
    [self startObservingDesktop];
}

- (IBAction)createConnection:(id)sender {
    connectionInfo = [[FTPInfo alloc] initWithHost:[host stringValue]
                                          username:[username stringValue]
                                          password:[password stringValue]];
}

- (void)onDirectoryNotification:(NSNotification *)n {
    id obj = [n object];
    if (obj && [obj isKindOfClass:[NSString class]]) {
        [self checkForScreenshotsAtPath:screenshotLocation];
    }
}

- (void)startObservingDesktop {
    if (shouldObserveDesktop)
        return;
    NSDistributedNotificationCenter *dnc = [NSDistributedNotificationCenter defaultCenter];
    [dnc addObserver:self selector:@selector(onDirectoryNotification:) name:@"com.apple.carbon.core.DirectoryNotification" object:nil suspensionBehavior:NSNotificationSuspensionBehaviorDeliverImmediately];
    shouldObserveDesktop = YES;
}

- (void)stopObservingDesktop {
    if (!shouldObserveDesktop)
        return;
    NSDistributedNotificationCenter *dnc = [NSDistributedNotificationCenter defaultCenter];
    [dnc removeObserver:self name:@"com.apple.carbon.core.DirectoryNotification" object:nil];
    shouldObserveDesktop = NO;
}

- (void)checkForScreenshotsAtPath:(NSString *)dirpath {		  
	NSDictionary *files;
	NSArray *paths;
    NSPasteboard *paste;
    NSString *uploadURL;
	
	// find new screenshots
	if (!(files = [self findUnprocessedScreenshotsOnDesktop]))
		return;
	
	// sort on key (path)
	paths = [files keysSortedByValueUsingComparator:^(id a, id b) { return [b compare:a]; }];
	
	// process each file
    paste = [NSPasteboard generalPasteboard];
    [paste clearContents];
	for (NSString *path in paths) {
        if(connectionInfo != nil)
        {
            uploadURL = [FTPConnection uploadFile:path 
                                     toConnection:[self connectionInfo]];
            [output setStringValue:uploadURL];
            [paste setString: uploadURL forType:NSStringPboardType];
        }
	}
}

- (NSDictionary *)findUnprocessedScreenshotsOnDesktop {
	NSDictionary *currentFiles;
	NSMutableDictionary *files;
	NSMutableSet *newFilenames;
	
	currentFiles = [self screenshotsOnDesktop];
	files = nil;
	
	if ([currentFiles count]) {
		newFilenames = [NSMutableSet setWithArray:[currentFiles allKeys]];
		// filter: remove allready processed screenshots
		[newFilenames minusSet:[NSSet setWithArray:[knownScreenshotsOnDesktop allKeys]]];
		if ([newFilenames count]) {
			files = [NSMutableDictionary dictionaryWithCapacity:1];
			for (NSString *path in newFilenames) {
				[files setObject:[currentFiles objectForKey:path] forKey:path];
			}
		}
	}
	
	knownScreenshotsOnDesktop = currentFiles;
	return files;
}

- (NSDictionary *)screenshotsOnDesktop {
	NSDate *lmod = [NSDate dateWithTimeIntervalSinceNow:-5]; // max 5 sec old
	return [self screenshotsAtPath:screenshotLocation modifiedAfterDate:lmod];
}

- (NSDictionary *)screenshotsAtPath:(NSString *)dirpath modifiedAfterDate:(NSDate *)lmod {
	NSFileManager *fm = [NSFileManager defaultManager];
	NSArray *direntries;
	NSMutableDictionary *files = [NSMutableDictionary dictionary];
	NSString *path;
	NSDate *mod;
	NSError *error;
	NSDictionary *attrs;
	
	dirpath = [dirpath stringByExpandingTildeInPath];
	
	direntries = [fm contentsOfDirectoryAtPath:dirpath error:&error];
	if (!direntries) {
		return nil;
	}
	
	for (NSString *fn in direntries) {
		
		//[log debug:@"%s testing %@", _cmd, fn];
		
		// always skip dotfiles
		if ([fn hasPrefix:@"."]) {
			//[log debug:@"%s skipping: filename begins with a dot", _cmd];
			continue;
		}
		
		// skip any file not ending in screenshotFilenameSuffix (".png" by default)
		if (([fn length] < 10) ||
			// ".png" suffix is expected
			(![fn compare:screenshotFilenameSuffix options:NSCaseInsensitiveSearch range:NSMakeRange([fn length]-5, 4)] != NSOrderedSame)
			)
		{
			continue;
		}
		
		// build path
		path = [dirpath stringByAppendingPathComponent:fn];
		
		// Skip any file which name does not contain a space.
		// You want to avoid matching the filename against
		// all possible screenshot file name schemas (must be hundreds), we make the
		// assumption that all language formats have this in common: it contains at least one space.
		if ([fn rangeOfString:@" "].location == NSNotFound) {
			continue;
		}
		
		// query file attributes (rich stat)
		attrs = [fm attributesOfItemAtPath:path error:&error];
		if (!attrs) {
			continue;
		}
		
		// must be a regular file
		if ([attrs objectForKey:NSFileType] != NSFileTypeRegular) {
			continue;
		}
		
		// check last modified date
		mod = [attrs objectForKey:NSFileModificationDate];
		if (lmod && (!mod || [mod compare:lmod] == NSOrderedAscending)) {
			// file is too old
			continue;
		}
		
		// find key for NSFileExtendedAttributes
		NSString *xattrsKey = nil;
		for (NSString *k in [attrs keyEnumerator]) {
			if ([k isEqualToString:@"NSFileExtendedAttributes"]) {
				xattrsKey = k;
				break;
			}
		}
		if (!xattrsKey) {
			// no xattrs
			continue;
		}
		NSDictionary *xattrs = [attrs objectForKey:xattrsKey];
		if (!xattrs || ![xattrs objectForKey:@"com.apple.metadata:kMDItemIsScreenCapture"]) {
			continue;
		}
		
		// ok, let's use this file
		[files setObject:mod forKey:path];
	}
	
	return files;
}

/**
 Implementation of dealloc, to release the retained variables.
 */

- (void)dealloc {
    
    [window release];
	
    [super dealloc];
}

@end
