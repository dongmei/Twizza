//
//  ZoeTwitterAccount.m
//  Twizza
//
//  Created by Dongmei Hu on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZoeTwitterAccount.h"

ZoeTwitterAccount* sharedAccount_ = nil;

@implementation ZoeTwitterAccount
@synthesize account = _account,twitterID = _twitterID;

+(ZoeTwitterAccount*)getSharedAccount{
    if (sharedAccount_ == nil){
        NSLog(@"account not set yet");
    }
    return sharedAccount_;
}

+(void)setACAccount:(ACAccount*)acc twitterID:(NSString*)tID{
    if (sharedAccount_ == nil){
        sharedAccount_ = [[ZoeTwitterAccount alloc] initWithACAccount:acc withID:tID];
    }else 
    {
        [ZoeTwitterAccount getSharedAccount].account = acc;
        [ZoeTwitterAccount getSharedAccount].twitterID = tID;
    }
    NSLog(@"setACAccount, passed account: %@",acc.username);
    NSLog(@"set twitterID, passed ID: %@",tID);
}


-(id)initWithACAccount:(ACAccount*)acc withID:(NSString*)twID{
    self = [super init];
    if (self){
        self.account = acc;
        self.twitterID = twID;
    }
    return  self;
}

-(NSString*)getUserName{
    return self.account.username;
}

-(NSString*)getTwitterID{
    return self.twitterID;
}

@end
