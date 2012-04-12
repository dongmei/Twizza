//
//  ZoeAddTopicViewController.m
//  Twizza
//
//  Created by Dongmei Hu on 2/15/12.
//  Copyright (c) 2012 Z&Z. All rights reserved.
//

#import "ZoeAddTopicViewController.h"

@interface ZoeAddTopicViewController()
- (id)jsonPostRequest:(NSData *)jsonPostRequestData;
@end

@implementation ZoeAddTopicViewController

@synthesize addedTopic,addedKeywords,addedSource;
@synthesize connection = _connection;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (id)jsonPostRequest:(NSData *)jsonPostRequestData
{
    NSString *requestString = [NSString stringWithFormat:@"%@/%@.php",TWIZZA_HOST_URL,ADD_NEW_TOPIC]; 
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
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
    
    NSString *topicName,*keywordString,*sourceString;
    topicName = self.addedTopic.text;
    keywordString = self.addedKeywords.text;
    sourceString = self.addedSource.text;
    
    NSDictionary* newTopic = [NSDictionary dictionaryWithObjectsAndKeys:topicName,@"topicName",keywordString,@"keywordString",sourceString,@"sourceString",[ZoeTwitterAccount getSharedAccount].twitterID,@"userID",nil];
    
    if ([NSJSONSerialization isValidJSONObject:newTopic]) {
        NSError *error=nil;
        NSData *result = [NSJSONSerialization dataWithJSONObject:newTopic options:NSURLRequestUseProtocolCachePolicy error:&error];
        
        if (error == nil && result != NULL) {
            [self jsonPostRequest:result];
            NSLog(@"tweet sent successully");
        }
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)cancelBtnDidPressed:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    [addedTopic setKeyboardType:UIKeyboardTypeTwitter];
    [addedTopic becomeFirstResponder];
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
