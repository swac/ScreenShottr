//
//  FTPInfo.m
//  ScreenShottr
//
//  Created by Ashwin Bhat on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FTPInfo.h"


@implementation FTPInfo

@synthesize username;
@synthesize password;
@synthesize host;
@synthesize filenames;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id) initWithHost:(NSString *)hostName username:(NSString *)user password:(NSString *)pw
{
    self = [super init];
    if(self)
    {
        [self setHost:hostName];
        [self setUsername:user];
        [self setPassword:pw];
        [self setFilenames:nil];
    }
    return self;
}

- (void) getListing
{
    CFReadStreamRef readStream;
    CFIndex bytesRead, bytesParsed;
    CFDictionaryRef listing;
    UInt8 *readBuffer;
    CFIndex readBufferIndex;
    int newlines;
    CFIndex offset;
    NSString *name;
    
    readBufferIndex = 0;
    newlines = 0;
    readBuffer = malloc(READ_BUFFER_SIZE * sizeof(*readBuffer));
    
    readStream = ftplisting([[self connectionURL] cStringUsingEncoding:NSUTF8StringEncoding]);
    
    bytesRead = CFReadStreamRead(readStream, readBuffer, READ_BUFFER_SIZE);
    
    [self setFilenames: [[NSMutableSet alloc] init]];
    offset = 0;
    do {
        bytesParsed = CFFTPCreateParsedResourceListing(kCFAllocatorSystemDefault, &readBuffer[offset], bytesRead - offset, &listing);
        offset += bytesParsed;
        name = [(NSDictionary *) listing objectForKey:@"kCFFTPResourceName"];
        if(name != nil)
        {
            [filenames addObject:name];
        }
    } while(bytesParsed > 0);
}

- (NSString *)connectionURL
{
    return [NSString stringWithFormat:@"ftp://%@:%@@%@/", username, password, host];
}

- (NSString *)connectionURLWithFilename:(NSString *)filename andExtension:(NSString *) extension
{
    return [NSString stringWithFormat:@"ftp://%@:%@@%@/%@.%@", username, password, host, filename, extension];
}

- (void)dealloc
{
    [super dealloc];
}

@end
