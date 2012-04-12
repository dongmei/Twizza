//
//  ZoeListViewController.h
//  Twizza
//
//  Created by Dongmei Hu on 12/17/11.
//  Copyright (c) 2011 Z&Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "ZoeTweetComposeViewController.h"
#import "ZoeTopicListViewController.h"
#import "ZoeTwitterAccount.h"
#import "constants.h"
#import "ZoeTweetViewController.h"
#import "ZoeTweet.h"

@interface ZoeListViewController : UITableViewController<ZoeTweetComposeViewControllerDelegate>

@property (strong, nonatomic) id timeline;

@end
