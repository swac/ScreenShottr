/*
 *  FTPConnection.c
 *  ScreenShottr
 *
 *  Created by Ashwin Bhat on 4/6/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "FTPConnection.h"

CFReadStreamRef ftplisting(const char *url) {
    CFURLRef ftpURL;
    CFReadStreamRef readStream;
    
    ftpURL = CFURLCreateWithBytes(kCFAllocatorSystemDefault,(UInt8 *)url,strlen(url),kCFStringEncodingASCII,nil);
    
    readStream = CFReadStreamCreateWithFTPURL(kCFAllocatorSystemDefault, ftpURL);
    if(!CFReadStreamOpen(readStream)) {
		printf("failed to open FTP connection to URL %s",url);
		cleanUpReadStream(readStream, ftpURL);
	}
    return readStream;
}

CFWriteStreamRef ftpconnect(const char *url, const char *path) {
	
	CFWriteStreamRef ftpWriteStream;
	CFURLRef ftpURL;
    
    ftpURL = CFURLCreateWithBytes(kCFAllocatorSystemDefault,(UInt8 *)url,strlen(url),kCFStringEncodingASCII,nil);
    
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
    
	
	ftpURL = CFURLCreateWithBytes(kCFAllocatorSystemDefault,(UInt8 *)url,strlen(url),kCFStringEncodingASCII,nil);
	ftpWriteStream = CFWriteStreamCreateWithFTPURL(kCFAllocatorSystemDefault, ftpURL);
	
	if (!CFWriteStreamOpen(ftpWriteStream)) {
		printf("failed to open FTP connection to URL %s",url);
		cleanUpWriteStream(ftpWriteStream, ftpURL);
	}
	
	return ftpWriteStream;
}

void cleanUpWriteStream(CFWriteStreamRef stream, CFURLRef url)
{
	CFWriteStreamClose(stream);
	
	CFRelease(stream);
	CFRelease(url);
}

void cleanUpReadStream(CFReadStreamRef stream, CFURLRef url)
{
	CFReadStreamClose(stream);
	
	CFRelease(stream);
	CFRelease(url);
}