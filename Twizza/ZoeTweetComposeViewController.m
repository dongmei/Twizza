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
@end


@implementation ZoeTweetComposeViewController

@synthesize tweetComposeDelegate = _tweetComposeDelegate;
@synthesize image = _image;
@synthesize imageView = _imageView;
@synthesize textView;
@synthesize choosePhoto = _choosePhoto;

//@synthesize closeButton;
//@synthesize sendButton;
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
-(IBAction) getPhoto:(id) sender {
    NSLog(@"Press choosePhoto");
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	
    /*
	if((UIButton *) sender == _choosePhoto) {
		picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	} else {
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	}*/
	
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
                                //parameters:[NSDictionary dictionaryWithObject:status forKey:@"status"] 
                                requestMethod:TWRequestMethodPOST];

    [requestSend setAccount:[ZoeTwitterAccount getSharedAccount].account]; 
    //NSLog(@"%@", self.image);
    
    if (self.image != NULL) {
        //add image
        NSLog(@"status: send tweet with image");
        NSData *imageData = UIImagePNGRepresentation(self.image);
        [requestSend addMultiPartData:imageData withName:@"media[]" type:@"multipart/form-data"];
        [requestSend addMultiPartData:[status dataUsingEncoding:NSUTF8StringEncoding] withName:@"status" type:@"multipart/form-data"];
    
    } 
    
    [requestSend performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        //NSDictionary *dict = 
		//(NSDictionary *)[NSJSONSerialization 
        // JSONObjectWithData:responseData options:0 error:nil];
        //NSLog(@"%@", dict);
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


/*
- (IBAction)cancel:(id)sender
{
    [self.tweetComposeDelegate tweetComposeViewController:self didFinishWithResult:TweetComposeResultCancelled];
}*/


@end
