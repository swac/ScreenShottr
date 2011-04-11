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

- (void) getListing
{
    CFIndex bytesRead, bytesParsed;
    CFDictionaryRef listing;
    UInt8 *readBuffer;
    CFIndex readBufferIndex;
    int newlines;
    CFIndex offset;
    NSString *name;
    struct read_stream *read;
    
    readBufferIndex = 0;
    newlines = 0;
    readBuffer = malloc(READ_BUFFER_SIZE * sizeof(*readBuffer));
    
    read = ftplisting([[connectionInfo connectionURL] cStringUsingEncoding:NSUTF8StringEncoding]);
    
    bytesRead = CFReadStreamRead(read->stream, readBuffer, READ_BUFFER_SIZE);
    
    [connectionInfo setFilenames: [[NSMutableSet alloc] init]];
    offset = 0;
    do {
        bytesParsed = CFFTPCreateParsedResourceListing(kCFAllocatorSystemDefault, &readBuffer[offset], bytesRead - offset, &listing);
        offset += bytesParsed;
        name = [(NSDictionary *) listing objectForKey:@"kCFFTPResourceName"];
        if(name != nil)
        {
            [[connectionInfo filenames] addObject:name];
        }
    } while(bytesParsed > 0);
}

- (IBAction)testConnection:(id)sender {
    NSString *filename, *extension, *inputFilePath;
    struct write_stream *write;
    
    
    filename = [NSString stringWithCString:random_filename(5) encoding:NSUTF8StringEncoding];
    inputFilePath = @"/Users/ashwin/Desktop/file2.png";
    extension = [inputFilePath pathExtension];
    
    write = ftpconnect([[connectionInfo connectionURLWithFilename:filename
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
		bytesWritten += CFWriteStreamWrite(write->stream, buf, bytesRead);
	}
	
	[inFile close];
	
	[output setIntValue:(int)bytesWritten];
}

@end
