/*
 *  FTPConnection.c
 *  ScreenShottr
 *
 *  Created by Ashwin Bhat on 4/6/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "FTPConnection.h"

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
    
    /*readBufferIndex = 0;
    readBuffer = malloc(READ_BUFFER_SIZE * sizeof(*readBuffer));
    
    readStream = CFReadStreamCreateWithFTPURL(kCFAllocatorSystemDefault, ftpURL);
    if(!CFReadStreamOpen(readStream)) {
		printf("failed to open FTP connection to URL %s",url);
		cleanUpWriteStream(ftpWriteStream, ftpURL);
	}
    bytesRead = CFReadStreamRead(readStream, readBuffer, READ_BUFFER_SIZE);
//    do {
//        bytesRead = CFReadStreamRead(readStream, readBuffer + readBufferIndex, READ_BUFFER_SIZE);
//        readBufferIndex += bytesRead;
//    } while(bytesRead > 0);
    
    bytesParsed = CFFTPCreateParsedResourceListing(kCFAllocatorSystemDefault, readBuffer, bytesRead, &listing);*/
    
	
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
}

void cleanUpReadStream(struct read_stream *read)
{
	CFReadStreamClose(read->stream);
	
	CFRelease(read->stream);
	CFRelease(read->ftpURL);
}