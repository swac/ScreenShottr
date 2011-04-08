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
	// Insert code here to initialize your application 
}

- (IBAction)createConnection:(id)sender {
    connectionInfo = [[FTPInfo alloc] initWithHost:[host stringValue]
                                          username:[username stringValue]
                                          password:[password stringValue]];
    NSLog(@"%s", [[connectionInfo connectionURL] cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (IBAction)testListing:(id)sender {
    NSDictionary *dict;
    NSEnumerator *enumerator;
    id key;
    CFReadStreamRef readStream;
    CFIndex bytesRead, bytesParsed;
    CFDictionaryRef listing;
    UInt8 *readBuffer;
    CFIndex readBufferIndex;
    NSArray *entries;
    NSString *read;
    NSMutableSet *filenames;
    
    readBufferIndex = 0;
    NSLog(@"here");
    readBuffer = malloc(READ_BUFFER_SIZE * sizeof(*readBuffer));
    
    readStream = ftplisting([[connectionInfo connectionURL] cStringUsingEncoding:NSUTF8StringEncoding]);
    
    bytesRead = CFReadStreamRead(readStream, readBuffer, READ_BUFFER_SIZE);
    
    read = [NSString stringWithCString:(char *)readBuffer encoding:NSUTF8StringEncoding];
    entries = [read componentsSeparatedByString:@"\n"];
    
    
    bytesParsed = CFFTPCreateParsedResourceListing(kCFAllocatorSystemDefault, readBuffer, bytesRead, &listing);
    dict = (NSDictionary *) listing;
    
    enumerator = [dict keyEnumerator];
    while((key = [enumerator nextObject]))
        NSLog(@"%@ : %@", key, [dict objectForKey:key]);
    NSLog(@"done");
    free(readBuffer);
}

- (IBAction)testConnection:(id)sender {
    char *path = "thing.png";    
    
	CFWriteStreamRef ftpWriteStream = ftpconnect([[connectionInfo connectionURL] cStringUsingEncoding:NSUTF8StringEncoding], path);
	
	uint8_t buf[BUFFER_SIZE]; 
	NSString *inputFilePath = @"/Users/ashwin/Desktop/file.png";
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
