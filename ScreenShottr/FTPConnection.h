/*
 *  FTPConnection.h
 *  ScreenShottr
 *
 *  Created by Ashwin Bhat on 4/6/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include <CoreServices/CoreServices.h>
#include <CoreFoundation/CoreFoundation.h>
#include <SystemConfiguration/SystemConfiguration.h>

#define READ_BUFFER_SIZE 16384

CFWriteStreamRef ftpconnect(const char *connectionURL, const char *path);
CFReadStreamRef ftplisting(const char *url);
void cleanUpWriteStream(CFWriteStreamRef stream, CFURLRef url);
void cleanUpReadStream(CFReadStreamRef stream, CFURLRef url);