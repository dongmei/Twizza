//
//  ZoeTweet.m
//  Twizza
//
//  Created by Dongmei Hu on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZoeTweet.h"

ZoeTweet* sharedTweet_ = nil;

@implementation ZoeTweet
@synthesize tweet;

+(ZoeTweet*)getSharedTweet{
    if (sharedTweet_ == nil){
        NSLog(@"account not set yet");
    }
    return sharedTweet_;
}

+(void)setTweet:(NSDictionary *)t{
    if (sharedTweet_ == nil){
        sharedTweet_ = [[ZoeTweet alloc] initWithTweet:t];
    }else 
    {
        [ZoeTweet getSharedTweet].tweet = t;
    }
}

-(id)initWithTweet:(NSDictionary *)t{
    self = [super init];
    if (self){
        self.tweet = t;
    }
    return  self;
}

-(NSString*)getUserName{
    if ([tweet valueForKey:@"user.name"]!=NULL) {
    return [tweet valueForKeyPath:@"user.name"];
    }
    else return [tweet valueForKey:@"from_user"];
}

-(NSString*)getTwitterID{
    if ([self.tweet objectForKey:@"id"]!=NULL) {
        return (NSString *)[self.tweet objectForKey:@"id"];
    }
    else return [tweet valueForKey:@"from_user_id_str"];
}

-(NSString*)getTweetText{
    return (NSString *)[self.tweet objectForKey:@"text"];
}

-(NSData*)getProfileURLData{
    NSString *imageURLString;
    
    if ([self.tweet valueForKeyPath:@"user.profile_image_url"]!=NULL) {
        imageURLString = [self.tweet valueForKeyPath:@"user.profile_image_url"];
    }else imageURLString = [self.tweet objectForKey:@"profile_image_url"];
    
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    NSData *profileImageData = [[NSData alloc] initWithContentsOfURL:imageURL];
    return profileImageData;
}


@end
