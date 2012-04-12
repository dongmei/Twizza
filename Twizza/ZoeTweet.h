//
//  ZoeTweet.h
//  Twizza
//
//  Created by Dongmei Hu on 3/17/12.
//  Copyright (c) 2012 Z&Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZoeTweet : NSObject
{    
    NSDictionary *tweet;
}


@property (strong, nonatomic) NSDictionary *tweet;

-(id)initWithTweet:(NSDictionary *)t;

+(ZoeTweet*)getSharedTweet;

+(void)setTweet:(NSDictionary *)t;

-(NSString*)getUserName;
-(NSString*)getTwitterID;
-(NSData*)getProfileURLData;
-(NSString*)getTweetText;

@end
