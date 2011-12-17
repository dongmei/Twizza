//
//  ZoeListViewController.h
//  Twizza
//
//  Created by Dongmei Hu on 12/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
//#import "ZoeTweetComposeViewController.h"

@interface ZoeListViewController : UITableViewController //<TweetComposeViewControllerDelegate>
{
    /*
    IBOutlet UIImageView *profileImage;
    IBOutlet UILabel *screenNameLable;
    IBOutlet UILabel *tweetContent; */
}

@property (strong, nonatomic) ACAccount *account;
@property (strong, nonatomic) id timeline;

@end
