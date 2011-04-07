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

CFWriteStreamRef ftpconnect();
void cleanUp(CFWriteStreamRef, CFURLRef);