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
@synthesize path;
@synthesize url;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id) initWithHost:(NSString *)hostName username:(NSString *)user password:(NSString *)pw path:(NSString *)serverPath url:(NSString *)siteURL
{
    self = [super init];
    if(self)
    {
        [self setHost:hostName];
        [self setUsername:user];
        [self setPassword:pw];
        [self setPath:serverPath];
        [self setUrl:siteURL];
    }
    return self;
}

- (NSString *)connectionURL
{
    return [NSString stringWithFormat:@"ftp://%@:%@@%@/", username, password, host];
}

- (NSURL *)connectionURLWithFilename:(NSString *)filename
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"ftp://%@:%@@%@/%@/%@", username, password, host, path, filename]];
}

- (void)dealloc
{
    [super dealloc];
}

@end
