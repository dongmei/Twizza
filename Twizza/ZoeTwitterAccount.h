//
//  ZoeTwitterAccount.h
//  Twizza
//
//  Created by Dongmei Hu on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@interface ZoeTwitterAccount : NSObject
{
    ACAccount *account;
    NSString *twitterID;
}

@property (strong, nonatomic) ACAccount *account;
@property (strong, nonatomic) NSString *twitterID;

//-(id)initWithACAccount:(ACAccount*)acc;
-(id)initWithACAccount:(ACAccount*)acc withID:(NSString*)twID;

+(ZoeTwitterAccount*)getSharedAccount;

+(void)setACAccount:(ACAccount*)acc twitterID:(NSString*)tID;

-(NSString*)getUserName;
-(NSString*)getTwitterID;
@end
