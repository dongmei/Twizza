//
//  ZoeTweetViewController.m
//  Twizza
//
//  Created by Dongmei Hu on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZoeTweetViewController.h"

@implementation ZoeTweetViewController

@synthesize userName,profileImage,tweeContent;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    //get data
    NSData *image = [[ZoeTweet getSharedTweet] getProfileURLData];
    NSString *uName = [[ZoeTweet getSharedTweet]getUserName];
    NSString *tContent = [[ZoeTweet getSharedTweet]getTweetText];
    
    //set display
    self.title = uName;
    [self.profileImage setImage:[UIImage imageWithData:image]];    
    [self.userName setText:uName];
    [self.tweeContent setText:tContent];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
