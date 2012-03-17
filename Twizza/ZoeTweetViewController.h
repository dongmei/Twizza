//
//  ZoeTweetViewController.h
//  Twizza
//
//  Created by Dongmei Hu on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoeTweet.h"

@interface ZoeTweetViewController : UIViewController
{
    UIImageView *profileImage;
    UILabel *userName;
    UILabel *tweetContent;
}

@property (nonatomic,strong) IBOutlet UIImageView *profileImage;
@property (nonatomic,strong) IBOutlet UILabel *userName;
@property (nonatomic,strong) IBOutlet UILabel *tweeContent;

@end
