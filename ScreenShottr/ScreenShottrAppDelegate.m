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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
}

- (IBAction)testConnection:(id)sender {
	
#define bufSize 1024 // er whatever
	
	CFWriteStreamRef ftpWriteStream = ftpconnect();
	
	uint8_t buf[bufSize]; 
	NSString *inputFilePath = @"/Users/ashwin/Desktop/file.png";
	NSInteger bytesRead;
	NSInteger written;
	
	NSInputStream *inFile = [NSInputStream inputStreamWithFileAtPath:inputFilePath];
	
	if (!inFile)
		[output setStringValue:@"shit's broke"];
	
	[inFile open];
	
	CFIndex bytesWritten = 0;
	while([inFile hasBytesAvailable]) {
		bytesRead = [inFile read:buf maxLength:bufSize];
		bytesWritten += CFWriteStreamWrite(ftpWriteStream, buf, bytesRead);
	}
	
	/* if (bytesWritten != bufSize) {
     printf("Not all data was written to the server %d / %d", bytesWritten, bufSize);
     cleanUp(ftpWriteStream, ftpURL);
     } else if (bytesWritten == -1) {
     printf("An error ocurred writing to stream %p",ftpWriteStream);
     cleanUp(ftpWriteStream, ftpURL);
     
     while ([inFile hasBytesAvailable]) {
     bytesRead = [inFile read:buf maxLength:bufSize];
     written = [(NSOutputStream *)ftpWriteStream write:buf maxLength:bytesRead];
     if([written intValue] == -1)
     {
     [output setStringValue:@"oh fuck"];
     break;
     }
     } */
	
	[inFile close];
	
	[output setIntValue:bytesWritten];
}

@end
