//
//  ZoeTweetComposeViewController.m
//  Twizza
//
//  Created by Dongmei Hu on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ZoeTweetComposeViewController.h"

@implementation ZoeTweetComposeViewController


@synthesize account = _account;
@synthesize tweetComposeDelegate = _tweetComposeDelegate;

//@synthesize closeButton;
//@synthesize sendButton;
@synthesize textView;
//@synthesize titleView;


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    //self.titleView.title = [NSString stringWithFormat:@"Compose Tweet"];    
    [textView setKeyboardType:UIKeyboardTypeTwitter];
    [textView becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.navigationController.navigationItem.leftBarButtonItem.title = @"Cancel";
}

/*
- (void)viewDidUnload
{
    [self setCloseButton:nil];
    [self setSendButton:nil];
    [self setTextView:nil];
    [self setTitleView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Actions
/*
- (IBAction)sendNewTweet:(id)sender
{
    if ([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
        [tweetSheet setInitialText:@"Tweeting from iOS 5 By Tutorials! :)"];
        
	    [self presentModalViewController:tweetSheet animated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" 
                                                            message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup" 
                                                           delegate:self 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
        [alertView show];
    }

}*/

-(IBAction)cancelBtnDidPressed:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)sendTweet1:(id)sender 
{
    NSString *status = self.textView.text;
    
    TWRequest *sendTweet = [[TWRequest alloc] 
                            initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1/statuses/update.json"] 
                            parameters:[NSDictionary dictionaryWithObjectsAndKeys:status, @"status", nil]
                            requestMethod:TWRequestMethodPOST];
    
     NSLog(@"Problem sending tweet: %@", status);
    sendTweet.account = self.account;
    [sendTweet performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if ([urlResponse statusCode] == 200) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tweetComposeDelegate tweetComposeViewController:self didFinishWithResult:TweetComposeResultSent];
            });
        }
        else {
            NSLog(@"Problem sending tweet: %@", error);
        }
    }];
}

/*
- (IBAction)cancel:(id)sender
{
    [self.tweetComposeDelegate tweetComposeViewController:self didFinishWithResult:TweetComposeResultCancelled];
}*/


@end
