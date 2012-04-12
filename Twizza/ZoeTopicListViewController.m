//
//  ZoeTopicListViewController.m
//  Twizza
//
//  Created by Dongmei Hu on 2/11/12.
//  Copyright (c) 2012 Z&Z. All rights reserved.
//


#import "ZoeTopicListViewController.h"

@interface ZoeTopicListViewController()
- (void)fetchData:(NSData *)responseData;
- (id)jsonPostRequest:(NSData *)jsonPostRequestData;
- (void)checkForWIFIConnection;
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
@end

@implementation ZoeTopicListViewController

@synthesize topicList;
@synthesize selectedKeywords = _selectedKeywords;
@synthesize userID = _userID;
@synthesize connection = _connection;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

}

#pragma mark - View lifecycle
-(IBAction)refresh:(id)sender{
    //get topic list of this user_name
    self.userID = [ZoeTwitterAccount getSharedAccount].twitterID;
    NSString *requestTopicString= [NSString stringWithFormat:@"%@/getusertopics.php?user_id=%@",TWIZZA_HOST_URL,self.userID];
    
    NSURL *requestTopicURL =[NSURL URLWithString:requestTopicString];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData* data = [NSData dataWithContentsOfURL: requestTopicURL];
        [self performSelectorOnMainThread:@selector(fetchData:) 
                               withObject:data waitUntilDone:YES];
        NSLog(@"complete fetch data");
    });
    
}
    
    
- (id)jsonPostRequest:(NSData *)jsonPostRequestData
{
    NSString *requestString = [NSString stringWithFormat:@"%@/sendweight.php",TWIZZA_HOST_URL]; 
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    
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


- (void)updateWeight:(NSString *)topidID
{
    NSDictionary* topicToBeUpdated = [NSDictionary dictionaryWithObjectsAndKeys:topidID,@"topicID",
                              self.userID,@"userID",nil];
    NSLog(@"topic is %@",topicToBeUpdated);
    
    if ([NSJSONSerialization isValidJSONObject:topicToBeUpdated]) {
        NSError *error=nil;
        NSData *result = [NSJSONSerialization dataWithJSONObject:topicToBeUpdated options:NSURLRequestUseProtocolCachePolicy error:&error];
        
        if (error == nil && result != NULL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSelectorOnMainThread:@selector(jsonPostRequest:) 
                                       withObject:result waitUntilDone:YES];
            });
            NSLog(@"send out weight update (aft dispatch)");
        }
    }       
}

- (void)fetchData:(NSData *)responseData
{
    //parse out the json data,and get user's topics from server
    NSError* error;
    
    NSArray* json = [NSJSONSerialization JSONObjectWithData:responseData //1
                                                    options:kNilOptions 
                                                      error:&error];
    self.topicList = [NSMutableArray arrayWithArray:json];
    
    [(UITableView*)self.view reloadData];
}

- (void)requestDeleteTopic:(NSData *)responseData
{
    //parse out the json data,and get user's topics from server
    //NSError* error;
    //NSMutableArray* json = [NSJSONSerialization JSONObjectWithData:responseData //1
                                                           //options:kNilOptions 
                                                             // error:&error];
    [(UITableView*)self.view reloadData];
}

- (void)deleteTopic
{
    NSDictionary *topic= [self.topicList objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
    NSString* topicID = [topic objectForKey:@"topic_id"];
    NSLog(@"delete %@",topicID);

    NSString *requestTopicString= [NSString stringWithFormat:@"%@/deleteusertopics.php?user_id=%@&topic_id=%@",TWIZZA_HOST_URL,self.userID,topicID];
    
    NSURL *requestTopicURL =[NSURL URLWithString:requestTopicString];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData* data = [NSData dataWithContentsOfURL: requestTopicURL];
        [self performSelectorOnMainThread:@selector(requestDeleteTopic:) 
                               withObject:data waitUntilDone:YES];
        NSLog(@"complete delete topic");
    });
}


//swipe to delete topic
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        [self deleteTopic];
        
		[self.topicList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}   
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*ZoeTweetSearchViewController *searchVC;
     
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.topicList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TopicCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *topic = [self.topicList objectAtIndex:[indexPath row]];
    
    UILabel *cellNameLabel = (UILabel *)[cell viewWithTag:1];
    [cellNameLabel setText:[topic objectForKey:@"topic_name"]];
    
    return cell;
}

#pragma mark - Check Wifi connection
- (void)checkForWIFIConnection {
    Reachability* wifiReach = [Reachability reachabilityForLocalWiFi];
    
    NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
    
    if (netStatus!=ReachableViaWiFi)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No WIFI available!", @"AlertView") 
                                                            message:NSLocalizedString(@"You have no wifi connection available. Please connect to a WIFI network.", @"AlertView") 
                                                           delegate:self 
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", @"AlertView") 
                                                  otherButtonTitles:NSLocalizedString(@"Open settings", @"AlertView"), nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
    }
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self checkForWIFIConnection];

    //get topic list of this user_name
    self.userID = [ZoeTwitterAccount getSharedAccount].twitterID;
    NSString *requestTopicString= [NSString stringWithFormat:@"%@/getusertopics.php?user_id=%@",TWIZZA_HOST_URL,self.userID];
    
    NSURL *requestTopicURL =[NSURL URLWithString:requestTopicString];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData* data = [NSData dataWithContentsOfURL: requestTopicURL];
        [self performSelectorOnMainThread:@selector(fetchData:) 
                               withObject:data waitUntilDone:YES];
        NSLog(@"complete fetch data");
    });
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.topItem.title = @"My Topics";
    [super viewWillAppear:animated];
    NSLog(@"topic list: view will appear");
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"searchTweets"]) {        
        NSLog(@"segue");
        ZoeTweetSearchViewController *vc = [segue destinationViewController];
        vc.topic = [self.topicList objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        NSString* topicID = [vc.topic objectForKey:@"topic_id"];
        
        [self updateWeight:topicID];
    }
}

@end
