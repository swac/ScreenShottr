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

#import "FTPInfo.h"
#import "NameGenerator.h"

#define BUFFER_SIZE 1024
#define READ_BUFFER_SIZE 16384

struct write_stream {
    CFWriteStreamRef stream;
    CFURLRef ftpURL;
};

struct read_stream {
    CFReadStreamRef stream;
    CFURLRef ftpURL;
};

@interface FTPConnection : NSObject {
@private
    
}

+ (bool) fileExists:(NSString *)filename withConnection: (FTPInfo *)connectionInfo;
+ (NSString *)uploadFile: (NSString *)inputFilePath toConnection:(FTPInfo *)connectionInfo;

struct read_stream * ftplisting(const char *url);
struct write_stream * ftpconnect(const char *connectionURL);
void cleanUpWriteStream(struct write_stream *write);
void cleanUpReadStream(struct read_stream *read);

@end
