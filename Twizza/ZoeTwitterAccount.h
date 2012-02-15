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
}

@property (strong, nonatomic) ACAccount *account;
@property (strong, nonatomic) NSString  *twitterID;

-(id)initWithACAccount:(ACAccount*)acc;

+(ZoeTwitterAccount*)getSharedAccount;

+(void)setACAccount:(ACAccount*)account;

-(NSString*)getUserName;
@end
