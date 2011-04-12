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
}

@property (copy) NSString *username;
@property (copy) NSString *password;
@property (copy) NSString *host;

- (id) initWithHost:(NSString *)hostName username:(NSString *)user password:(NSString *)pw;
- (NSString *) connectionURL;
- (NSString *)connectionURLWithFilename:(NSString *)filename;

@end
