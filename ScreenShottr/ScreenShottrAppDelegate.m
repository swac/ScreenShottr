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
    NSLog(@"%s", [[connectionInfo connectionURL] cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (IBAction)testConnection:(id)sender {
    NSString *filename, *extension, *inputFilePath;
    
    
    filename = [NSString stringWithCString:random_filename(5) encoding:NSUTF8StringEncoding];
    inputFilePath = @"/Users/ashwin/Desktop/file2.png";
    extension = [inputFilePath pathExtension];
    
    CFWriteStreamRef ftpWriteStream = ftpconnect([[connectionInfo connectionURLWithFilename:filename
                                                                              andExtension:extension] cStringUsingEncoding:NSUTF8StringEncoding]);
	
	uint8_t buf[BUFFER_SIZE]; 
	NSInteger bytesRead;
	
	NSInputStream *inFile = [NSInputStream inputStreamWithFileAtPath:inputFilePath];
	
	if (!inFile)
		[output setStringValue:@"shit's broke"];
	
	[inFile open];
	
	CFIndex bytesWritten = 0;
	while([inFile hasBytesAvailable]) {
		bytesRead = [inFile read:buf maxLength:BUFFER_SIZE];
		bytesWritten += CFWriteStreamWrite(ftpWriteStream, buf, bytesRead);
	}
	
	[inFile close];
	
	[output setIntValue:(int)bytesWritten];
}

@end
