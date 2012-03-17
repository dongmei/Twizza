//
//  ZoeTweet.h
//  Twizza
//
//  Created by Dongmei Hu on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZoeTweet : NSObject
{
    /*
    NSString *userName;
    NSString *twitterID;
    NSString *tweetContent;
    NSData *profileImage;
     */
    
    NSDictionary *tweet;
}

/*
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *twitterID;
@property (strong, nonatomic) NSString *tweetContent;
@property (strong, nonatomic) NSData *profileImage;
 */
@property (strong, nonatomic) NSDictionary *tweet;

-(id)initWithTweet:(NSDictionary *)t;

+(ZoeTweet*)getSharedTweet;

+(void)setTweet:(NSDictionary *)t;

-(NSString*)getUserName;
-(NSString*)getTwitterID;
-(NSData*)getProfileURLData;
-(NSString*)getTweetText;

@end
