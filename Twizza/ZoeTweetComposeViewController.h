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


@interface ZoeTweetComposeViewController : UIViewController

@property (strong, nonatomic, readwrite) ACAccount *account;


//@property (strong, nonatomic) IBOutlet UIBarButtonItem *closeButton;
//@property (strong, nonatomic) IBOutlet UIBarButtonItem *sendButton;
@property (strong, nonatomic) IBOutlet UITextView *textView;
//@property (strong, nonatomic) IBOutlet UINavigationItem *titleView;


- (IBAction)sendTweet1:(id)sender;
//- (IBAction)cancel:(id)sender;
-(IBAction)cancelBtnDidPressed:(id)sender;

@property (nonatomic, assign) id<ZoeTweetComposeViewControllerDelegate> tweetComposeDelegate; 

@end