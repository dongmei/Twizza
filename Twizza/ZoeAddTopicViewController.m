//
//  ZoeAddTopicViewController.m
//  Twizza
//
//  Created by Dongmei Hu on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZoeAddTopicViewController.h"



@interface ZoeAddTopicViewController()
- (id)jsonPostRequest:(NSData *)jsonPostRequestData;
@end

@implementation ZoeAddTopicViewController

@synthesize addedTopic,addedKeywords;
@synthesize connection = _connection;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (id)jsonPostRequest:(NSData *)jsonPostRequestData
{
    //NSURL *url = [NSURL URLWithString:@"http://localhost:8888/addNewTopic.php"];
    NSString *requestString = [NSString stringWithFormat:@"%@/addNewTopic.php",TWIZZA_HOST_URL]; 
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d",[jsonPostRequestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonPostRequestData];
    
    NSError *error = nil;
    
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    assert(self.connection != nil);
    
    if (error == nil) {
        NSLog(@"connection error:nil");
        return self.connection;
    }
    
    return nil;
}    


#pragma mark - Actions
-(IBAction)addNewTopic:(id) sender {
    
    [sender resignFirstResponder];
    
    NSString *topicName,*keywordString;
    topicName = self.addedTopic.text;
    keywordString = self.addedKeywords.text;
    NSLog(@"add topic:%@,with keywords:%@ ",topicName,keywordString);
    
    NSDictionary* newTopic = [NSDictionary dictionaryWithObjectsAndKeys:topicName,@"topicName",keywordString,@"keywordString",[ZoeTwitterAccount getSharedAccount].twitterID,@"userID",nil];
    NSLog(@"%@",newTopic);
    
    if ([NSJSONSerialization isValidJSONObject:newTopic]) {
        NSError *error=nil;
        NSData *result = [NSJSONSerialization dataWithJSONObject:newTopic options:NSURLRequestUseProtocolCachePolicy error:&error];
        
        if (error == nil && result != NULL) {
            NSLog(@"json serialization: %@",result);
            [self jsonPostRequest:result];
            NSLog(@"tweet sent successully");
        }
    }
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    //self.titleView.title = [NSString stringWithFormat:@"Add New Topic"];    
    [addedTopic setKeyboardType:UIKeyboardTypeTwitter];
    [addedTopic becomeFirstResponder];
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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
