//
//  ZoeTweetComposeViewController.h
//  Twizza
//
//  Created by Dongmei Hu on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "ZoeTwitterAccount.h"

@class ZoeTweetComposeViewController;

enum TweetComposeResult {
    TweetComposeResultCancelled,
    TweetComposeResultSent,
    TweetComposeResultFailed
};
typedef enum TweetComposeResult TweetComposeResult;



@protocol ZoeTweetComposeViewControllerDelegate <NSObject>
- (void)tweetComposeViewController:(ZoeTweetComposeViewController *)controller didFinishWithResult:(TweetComposeResult)result;
@end



@interface ZoeTweetComposeViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImageView *_imageView;
}

@property (strong, nonatomic) IBOutlet UITextView *textView;
//@property (strong, nonatomic) IBOutlet UINavigationItem *titleView;
@property (nonatomic, assign) id<ZoeTweetComposeViewControllerDelegate> tweetComposeDelegate; 
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton * choosePhoto;

-(IBAction)getPhoto:(id) sender;
-(IBAction)sendTweet1:(id)sender;
-(IBAction)cancelBtnDidPressed:(id)sender;


@end