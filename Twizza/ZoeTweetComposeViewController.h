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



@interface ZoeTweetComposeViewController : UIViewController <UIImagePickerControllerDelegate>
{
    UIImageView *_imageView;
}

@property (strong, nonatomic) ACAccount *account;
@property (strong, nonatomic) IBOutlet UITextView *textView;
//@property (strong, nonatomic) IBOutlet UINavigationItem *titleView;
@property (nonatomic, assign) id<ZoeTweetComposeViewControllerDelegate> tweetComposeDelegate; 
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton * choosePhoto;

-(IBAction) getPhoto:(id) sender;
- (IBAction)sendTweet1:(id)sender;
-(IBAction)cancelBtnDidPressed:(id)sender;

@end