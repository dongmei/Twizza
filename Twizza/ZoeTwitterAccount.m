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

+(void)setACAccount:(ACAccount*)account{
    if (sharedAccount_ == nil){
        sharedAccount_ = [[ZoeTwitterAccount alloc] initWithACAccount:account];
        NSLog(@"initial nil, setACAccount: %@",sharedAccount_.account.username);
    }else sharedAccount_.account = account;
    NSLog(@"not nil, passed account: %@",account.username);
}

-(id)initWithACAccount:(ACAccount*)acc{
    self = [super init];
    if (self){
        self.account = acc;
        self.twitterID = 0;
    }
    return  self;
}

-(NSString*)getUserName{
    return self.account.username;
}

@end
