//
//  ZoeTopicListViewController.h
//  Twizza
//
//  Created by Dongmei Hu on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "ZoeAddTopicViewController.h"
#import "ZoeTweetSearchViewController.h"
#import "ZoeTwitterAccount.h"
#import "constants.h"

@interface ZoeTopicListViewController : UITableViewController

@property (strong, nonatomic) NSArray *topicList;
@property (strong, nonatomic) NSArray *selectedKeywords;

- (void)getKeywords;


@end
