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

@interface ZoeTweetSearchViewController : UITableViewController
{
    NSDictionary *topic;
}

@property (strong, nonatomic) id tweetList;
@property (strong, nonatomic) NSDictionary *topic;

@end
