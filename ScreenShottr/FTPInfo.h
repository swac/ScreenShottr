//
//  FTPInfo.h
//  ScreenShottr
//
//  Created by Ashwin Bhat on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTPInfo : NSObject {
@private
    NSString *username;
    NSString *password;
    NSString *host;
    NSString *path;
    NSString *url;
}

@property (copy) NSString *username;
@property (copy) NSString *password;
@property (copy) NSString *host;
@property (copy) NSString *path;
@property (copy) NSString *url;

- (id) initWithHost:(NSString *)hostName username:(NSString *)user password:(NSString *)pw path:(NSString *)serverPath url:(NSString *)siteURL;
- (NSString *) connectionURL;
- (NSURL *)connectionURLWithFilename:(NSString *)filename;

@end
