//
//  ZoeTweetSearchViewController.h
//  Twizza
//
//  Created by Dongmei Hu on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoeTwitterAccount.h"
#import "constants.h"
#import "ZoeTweet.h"

@interface ZoeTweetSearchViewController : UITableViewController
{
    NSDictionary *topic;
}

@property (strong, atomic) NSMutableArray *tweetList;
@property (strong, nonatomic) NSDictionary *topic;

@end
