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
    free(readBuffer);
    cleanUpReadStream(read);
}

- (IBAction)testConnection:(id)sender {
    NSString *filename, *extension, *inputFilePath;
    struct write_stream *write;
	NSInteger bytesRead;
    NSInputStream *inFile;
    uint8_t *buffer;
    bool collision;
    char *cName;
    
    [self getListing];
    buffer = (uint8_t *) malloc(BUFFER_SIZE * sizeof(*buffer));
    
    inputFilePath = @"~/Desktop/file2.png";
    inputFilePath = [inputFilePath stringByExpandingTildeInPath];
    extension = [inputFilePath pathExtension];
    
    collision = YES;
    while(collision) {
        cName = random_filename(5);
        filename = [NSString stringWithFormat:@"%s.%@", cName, extension];
        free(cName);
        if(![[connectionInfo filenames] containsObject:filename])
            collision = NO;
    }
    
    write = ftpconnect([[connectionInfo connectionURLWithFilename:filename] 
                            cStringUsingEncoding:NSUTF8StringEncoding]);
	
	inFile = [NSInputStream inputStreamWithFileAtPath:inputFilePath];
	
	if (!inFile)
		[output setStringValue:@"shit's broke"];
	
	[inFile open];
	
	CFIndex bytesWritten = 0;
	while([inFile hasBytesAvailable]) {
		bytesRead = [inFile read:buffer maxLength:BUFFER_SIZE];
		bytesWritten += CFWriteStreamWrite(write->stream, buffer, bytesRead);
	}
	
	[inFile close];
    free(buffer);
    cleanUpWriteStream(write);
	
	[output setStringValue:filename];
}

@end
