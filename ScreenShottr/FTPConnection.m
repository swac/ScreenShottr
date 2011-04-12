//
//  FTPConnection.m
//  ScreenShottr
//
//  Created by Ashwin Bhat on 4/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FTPConnection.h"


@implementation FTPConnection

+ (bool) fileExists:(NSString *)filename withConnection: (FTPInfo *)connectionInfo {
    struct read_stream *read;
    CFIndex bytesRead;
    UInt8 *readBuffer;
    
    read = ftplisting([[connectionInfo connectionURLWithFilename:filename] cStringUsingEncoding:NSUTF8StringEncoding]);
    readBuffer = (UInt8 *) malloc(READ_BUFFER_SIZE * sizeof(*readBuffer));
    bytesRead = CFReadStreamRead(read->stream, readBuffer, READ_BUFFER_SIZE);
    free(readBuffer);
    return bytesRead != -1;
}

+ (NSString *)uploadFile: (NSString *)inputFilePath toConnection:(FTPInfo *)connectionInfo {
    NSString *filename, *extension;
    struct write_stream *write;
	NSInteger bytesRead;
    NSInputStream *inFile;
    uint8_t *buffer;
    bool collision;
    char *cName;
    NSString *returnValue;
    
    returnValue = nil;
    buffer = (uint8_t *) malloc(BUFFER_SIZE * sizeof(*buffer));
    
    inputFilePath = [inputFilePath stringByExpandingTildeInPath];
    extension = [inputFilePath pathExtension];
    
    collision = YES;
    while(collision) {
        cName = random_filename(5);
        filename = [NSString stringWithFormat:@"%s.%@", cName, extension];
        free(cName);
        collision = [FTPConnection fileExists:filename withConnection:connectionInfo];
    }
    
    write = ftpconnect([[connectionInfo connectionURLWithFilename:filename] 
                        cStringUsingEncoding:NSUTF8StringEncoding]);
	
	inFile = [NSInputStream inputStreamWithFileAtPath:inputFilePath];
	
	if (!inFile)
		returnValue = @"shit's broke";
	
	[inFile open];
	
	CFIndex bytesWritten = 0;
	while([inFile hasBytesAvailable]) {
		bytesRead = [inFile read:buffer maxLength:BUFFER_SIZE];
		bytesWritten += CFWriteStreamWrite(write->stream, buffer, bytesRead);
	}
	
	[inFile close];
    free(buffer);
    cleanUpWriteStream(write);
	
    if(returnValue == nil)
        returnValue = filename;
	return returnValue;
}

struct read_stream * ftplisting(const char *url) {
    struct read_stream *read;
    
    read = (struct read_stream *) malloc(sizeof(*read));
    read->ftpURL = CFURLCreateWithBytes(kCFAllocatorSystemDefault,(UInt8 *)url,strlen(url),kCFStringEncodingASCII,nil);
    read->stream = CFReadStreamCreateWithFTPURL(kCFAllocatorSystemDefault, read->ftpURL);
    if(!CFReadStreamOpen(read->stream)) {
		printf("failed to open FTP connection to URL %s",url);
		cleanUpReadStream(read);
	}
    return read;
}

struct write_stream * ftpconnect(const char *url) {
    
    struct write_stream *write;
	
    write = (struct write_stream *) malloc(sizeof(*write));   
	write->ftpURL = CFURLCreateWithBytes(kCFAllocatorSystemDefault,(UInt8 *)url,strlen(url),kCFStringEncodingASCII,nil);
	write->stream = CFWriteStreamCreateWithFTPURL(kCFAllocatorSystemDefault, write->ftpURL);
	if (!CFWriteStreamOpen(write->stream)) {
		printf("failed to open FTP connection to URL %s",url);
		cleanUpWriteStream(write);
	}
	return write;
}

void cleanUpWriteStream(struct write_stream *write)
{
	CFWriteStreamClose(write->stream);
	
	CFRelease(write->stream);
	CFRelease(write->ftpURL);
    
    free(write);
}

void cleanUpReadStream(struct read_stream *read)
{
	CFReadStreamClose(read->stream);
	
	CFRelease(read->stream);
	CFRelease(read->ftpURL);
    
    free(read);
}

@end
