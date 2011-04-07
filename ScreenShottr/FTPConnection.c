/*
 *  FTPConnection.c
 *  ScreenShottr
 *
 *  Created by Ashwin Bhat on 4/6/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "FTPConnection.h"

CFWriteStreamRef ftpconnect() {
	const UInt8 *buf; // this is where your data to write to the server lives
	CFIndex bufSize; // and this is how big it is
	bufSize = 0;
	
	CFWriteStreamRef ftpWriteStream;
	CFURLRef ftpURL;
	
	char url[] = "ftp://screenshottr:screentest@padres.dreamhost.com/testpic.png";
	
	ftpURL = CFURLCreateWithBytes(kCFAllocatorSystemDefault,(UInt8 *)url,strlen(url),kCFStringEncodingASCII,nil);
	ftpWriteStream = CFWriteStreamCreateWithFTPURL(kCFAllocatorSystemDefault, ftpURL);
	
	/* CFWriteStreamSetProperty(ftpWriteStream, kCFStreamPropertyFTPPassword,"screentest"); */
	
	if (!CFWriteStreamOpen(ftpWriteStream)) {
		printf("failed to open FTP connection to URL %s",url);
		cleanUp(ftpWriteStream, ftpURL);
	}
	
	/* CFIndex bytesWritten = 0;
     bytesWritten = CFWriteStreamWrite(ftpWriteStream,buf,bufSize);
     
     if (bytesWritten != bufSize) {
     printf("Not all data was written to the server %d / %d", bytesWritten, bufSize);
     cleanUp(ftpWriteStream, ftpURL);
     } else if (bytesWritten == -1) {
     printf("An error ocurred writing to stream %p",ftpWriteStream);
     cleanUp(ftpWriteStream, ftpURL);
     } */
	
	return ftpWriteStream;
}

void cleanUp(CFWriteStreamRef stream, CFURLRef url)
{
	CFWriteStreamClose(stream);
	
	CFRelease(stream);
	CFRelease(url);
}