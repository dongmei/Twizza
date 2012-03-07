//
//  ZoeTopicListViewController.m
//  Twizza
//
//  Created by Dongmei Hu on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "ZoeTopicListViewController.h"

/*
@interface ZoeTopicListViewController()
- (id)requestDeleteTopic:(NSData *)jsonPostRequestData;
@end
*/

@implementation ZoeTopicListViewController

@synthesize topicList;
@synthesize selectedKeywords = _selectedKeywords;
@synthesize userID = _userID;
@synthesize connection = _connection;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
/*
- (void)getKeywords
{
    NSString *requestTopicString= [NSString stringWithFormat:@"%@/getkeywords.php?user_id=%@",TWIZZA_HOST_URL,self.userID];
    
    NSURL *requestTopicURL =[NSURL URLWithString:requestTopicString];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData* data = [NSData dataWithContentsOfURL: requestTopicURL];
        [self performSelectorOnMainThread:@selector(fetchKeywords:) 
                               withObject:data waitUntilDone:YES];
        NSLog(@"complete fetch keyewords");
    });
}*/


- (void)fetchData:(NSData *)responseData
{
    NSLog(@"topic list: fetch data");
    //parse out the json data,and get user's topics from server
    NSError* error;
    NSArray* json = [NSJSONSerialization JSONObjectWithData:responseData //1
                                                    options:kNilOptions 
                                                      error:&error];
    //self.topicList = json;
    self.topicList = [NSMutableArray arrayWithArray:json];
    
    NSLog(@"%@",json);
    [(UITableView*)self.view reloadData];
    NSLog(@"fetchData: reload data successfully");
}

- (void)requestDeleteTopic:(NSData *)responseData
{
    NSLog(@"delete topic: request data");
    //parse out the json data,and get user's topics from server
    NSError* error;
    NSMutableArray* json = [NSJSONSerialization JSONObjectWithData:responseData //1
                                                           options:kNilOptions 
                                                             error:&error];
    [(UITableView*)self.view reloadData];
    
    NSLog(@"%@",json);
}


/*
//request Server to delete topic
- (id)requestDeleteTopic:(NSData *)jsonPostRequestData
{
    
    NSLog(@"request delete topic");
    NSString *requestString = [NSString stringWithFormat:@"%@/deleteusertopics.php",TWIZZA_HOST_URL]; 
    NSURL *url = [NSURL URLWithString:requestString];
    NSLog(@"%@",url);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];

    NSLog(@"set request");
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d",[jsonPostRequestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonPostRequestData];
    
    NSError *error = nil;
    
    NSLog(@"build connection");
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    assert(self.connection != nil);
    
    if (error == nil) {
        NSLog(@"connection error:nil");
        return self.connection;
    }

    return nil;
}*/


- (void)deleteTopic
{
    NSLog(@"deleteTopic called");


    NSDictionary *topic= [self.topicList objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];//@"3";
    //NSLog(@"%@",topic);
    NSString* topicID = [topic objectForKey:@"topic_id"];
    //NSLog(@"topic id is %@",topicID);
    
    /*
    NSDictionary* TopicToBeDeleted = [NSDictionary dictionaryWithObjectsAndKeys:topicID,@"topic_id",self.userID,@"user_id",nil];
    NSLog(@"%@",TopicToBeDeleted);
    
    if ([NSJSONSerialization isValidJSONObject:TopicToBeDeleted]) {
        NSError *error=nil;
        NSData *result = [NSJSONSerialization dataWithJSONObject:TopicToBeDeleted options:NSURLRequestUseProtocolCachePolicy error:&error];
        
        if (error == nil && result != NULL) {
            NSLog(@"json serialization: %@",result);
            [self requestDeleteTopic:result];
            NSLog(@"topic deleted successully");
        }
    }*/
    

    NSString *requestTopicString= [NSString stringWithFormat:@"%@/deleteusertopics.php?user_id=%@&topic_id=%@",TWIZZA_HOST_URL,self.userID,topicID];
    NSLog(@"requestion delete string %@",requestTopicString);
    
    NSURL *requestTopicURL =[NSURL URLWithString:requestTopicString];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData* data = [NSData dataWithContentsOfURL: requestTopicURL];
        NSLog(@"data is %@",data);
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
        NSLog(@"call deleteTopic");
        //[self deleteTopic];
        
        NSLog(@"%d",indexPath.row);
        NSLog(@"%@",self.topicList);
		//[self.topicList removeObjectAtIndex:indexPath.row];
        [self.topicList removeLastObject];
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




/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure we're referring to the correct segue
    NSLog(@"segue");
    if ([[segue identifier] isEqualToString:@"AddTopics"]) {        
        ZoeAddTopicViewController *vc = [segue destinationViewController];
        
        vc.account=[ZoeTwitterAccount getSharedAccount].account;
    }
    
}*/
 
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Topic list: view did load");
    
    [self checkForWIFIConnection];

    //get topic list of this user_name
    //NSString *accountName = [ZoeTwitterAccount getSharedAccount].account.username;
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
    // Make sure we're referring to the correct segue
    if ([[segue identifier] isEqualToString:@"searchTweets"]) {        
        NSLog(@"segue");
        ZoeTweetSearchViewController *vc = [segue destinationViewController];
        vc.topic = [self.topicList objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
    }
}

@end
