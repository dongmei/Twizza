//
//  ZoeTopicListViewController.h
//  Twizza
//
//  Created by Dongmei Hu on 2/11/12.
//  Copyright (c) 2012 Z&Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "ZoeAddTopicViewController.h"
#import "ZoeTweetSearchViewController.h"
#import "ZoeTwitterAccount.h"
#import "constants.h"
#import "Reachability.h"


@interface ZoeTopicListViewController : UITableViewController
{
    NSURLConnection * _connection;
}

@property (strong, nonatomic) NSMutableArray *topicList;
@property (strong, nonatomic) NSArray *selectedKeywords;
@property (strong, nonatomic) NSString *userID;
@property (nonatomic, retain) NSURLConnection * connection; 


- (void)deleteTopic;
- (void)updateWeight:(NSString *)topidID;
- (void)requestDeleteTopic:(NSData *)responseData;

-(IBAction)refresh:(id) sender;

@end
