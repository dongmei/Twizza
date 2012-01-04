//
//  ZoeTweetComposeViewController.m
//  Twizza
//
//  Created by Dongmei Hu on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ZoeTweetComposeViewController.h"

@interface ZoeTweetComposeViewController ()
@property (strong, nonatomic) UIImage *image;
//@property (strong, nonatomic) NSString *url;
//- (void)clearLabels;
@end



@implementation ZoeTweetComposeViewController

@synthesize account = _account;
@synthesize tweetComposeDelegate = _tweetComposeDelegate;
@synthesize image = _image;

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
    NSString *urlRequestString;
    
    //self.image =[UIImage imageNamed:@"image1.png"];
    
    if (self.image !=NULL)
        urlRequestString = @"https://upload.twitter.com/1/statuses/update_with_media.json";
    else urlRequestString = @"https://api.twitter.com/1/statuses/update.json";
    
    
    
 
    TWRequest *sendTweet = [[TWRequest alloc] 
                                initWithURL:[NSURL URLWithString:urlRequestString] 
                                parameters:[NSDictionary dictionaryWithObjectsAndKeys:status, @"status", nil]
                                //parameters:[NSDictionary dictionaryWithObject:status forKey:@"status"] 
                                requestMethod:TWRequestMethodPOST];


        
    NSLog(@"Tweet content: %@", status);
    [sendTweet setAccount:self.account];
    NSLog(@"TWITTER USERNAME %@",[self.account username]);
    NSLog(@"%@", self.image);
    
    if (self.image != NULL) {
        //add image
        NSLog(@"status: send tweet with image");
        NSData *imageData = UIImagePNGRepresentation(self.image);
        [sendTweet addMultiPartData:imageData withName:@"media[]" type:@"multipart/form-data"];
        [sendTweet addMultiPartData:[status dataUsingEncoding:NSUTF8StringEncoding] withName:@"status" type:@"multipart/form-data"];
    
    [sendTweet performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSDictionary *dict = 
		(NSDictionary *)[NSJSONSerialization 
                         JSONObjectWithData:responseData options:0 error:nil];
        NSLog(@"%@", dict);
        NSLog(@"Twitter response, HTTP response: %i", [urlResponse statusCode]);
        if ([urlResponse statusCode] == 200) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tweetComposeDelegate tweetComposeViewController:self didFinishWithResult:TweetComposeResultSent];
            });
        }
        else {
            NSLog(@"Problem sending tweet: %@", error);
        }
    }];
    } else{
        //plain text 
        [sendTweet performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            NSLog(@"Twitter response, HTTP response: %i", [urlResponse statusCode]);
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
    
    
    [self dismissModalViewControllerAnimated:YES];
}

/*
- (IBAction)cancel:(id)sender
{
    [self.tweetComposeDelegate tweetComposeViewController:self didFinishWithResult:TweetComposeResultCancelled];
}*/


@end
