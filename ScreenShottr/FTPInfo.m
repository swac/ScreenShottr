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
    }
    return self;
}

- (NSString *)connectionURL
{
    return [NSString stringWithFormat:@"ftp://%@:%@@%@/", username, password, host];
}

- (NSString *)connectionURLWithFilename:(NSString *)filename
{
    return [NSString stringWithFormat:@"ftp://%@:%@@%@/%@", username, password, host, filename];
}

- (void)dealloc
{
    [super dealloc];
}

@end
