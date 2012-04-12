//
//  ZoeTweetComposeViewController.m
//  Twizza
//
//  Created by Dongmei Hu on 12/23/11.
//  Copyright (c) 2011 Z&Z. All rights reserved.
//

#import "ZoeTweetComposeViewController.h"

@interface ZoeTweetComposeViewController ()
@property (strong, nonatomic) UIImage *image;
@end


@implementation ZoeTweetComposeViewController

@synthesize tweetComposeDelegate = _tweetComposeDelegate;
@synthesize image = _image;
@synthesize imageView = _imageView;
@synthesize textView;
@synthesize choosePhoto = _choosePhoto;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [textView setKeyboardType:UIKeyboardTypeTwitter];
    [textView becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.navigationController.navigationItem.leftBarButtonItem.title = @"Cancel";
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Actions
-(IBAction) getPhoto:(id) sender {
    NSLog(@"Press choosePhoto");
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	
	[self presentModalViewController:picker animated:YES];
}

-(IBAction)cancelBtnDidPressed:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)sendTweet1:(id)sender 
{
    NSString *status = self.textView.text;
    NSString *urlRequestString;
    
    self.image = self.imageView.image;
    
    if (self.image !=NULL)
        urlRequestString = @"https://upload.twitter.com/1/statuses/update_with_media.json";
    else urlRequestString = @"https://api.twitter.com/1/statuses/update.json";
    
    TWRequest *requestSend = [[TWRequest alloc] 
                                initWithURL:[NSURL URLWithString:urlRequestString] 
                                parameters:[NSDictionary dictionaryWithObjectsAndKeys:status, @"status", nil] 
                                requestMethod:TWRequestMethodPOST];

    [requestSend setAccount:[ZoeTwitterAccount getSharedAccount].account]; 
    
    if (self.image != NULL) {
        //add image
        NSLog(@"status: send tweet with image");
        NSData *imageData = UIImagePNGRepresentation(self.image);
        [requestSend addMultiPartData:imageData withName:@"media[]" type:@"multipart/form-data"];
        [requestSend addMultiPartData:[status dataUsingEncoding:NSUTF8StringEncoding] withName:@"status" type:@"multipart/form-data"];
    
    } 
    
    [requestSend performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
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

    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"Open photo library");
	[picker dismissModalViewControllerAnimated:YES];
    [self.imageView setImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
}


@end
