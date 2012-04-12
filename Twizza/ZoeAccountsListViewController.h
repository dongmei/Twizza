//
//  ZoeAccountsListViewController.h
//  Twizza
//
//  Created by Dongmei Hu on 12/17/11.
//  Copyright (c) 2011 Z&Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "ZoeListViewController.h"
#import "ZoeTwitterAccount.h"
#import "constants.h"
#import "Reachability.h"

@interface ZoeAccountsListViewController : UITableViewController <UIAlertViewDelegate>

@property (strong, nonatomic) ACAccountStore *accountStore; 
@property (strong, nonatomic) NSArray *accounts;

- (void)checkForWIFIConnection;

@end
