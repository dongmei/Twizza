//
//  ZoeTopicListViewController.m
//  Twizza
//
//  Created by Dongmei Hu on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "ZoeTopicListViewController.h"

@implementation ZoeTopicListViewController

@synthesize topicList = _topicList;
@synthesize selectedKeywords = _selectedKeywords;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

#pragma mark - Table view data source

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

#pragma mark - Table view delegate

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



/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)getKeywords
{
    NSString *userID = [ZoeTwitterAccount getSharedAccount].twitterID;
    NSString *requestTopicString= [NSString stringWithFormat:@"%@/getkeywords.php?user_id=%@",TWIZZA_HOST_URL,userID];
    
    NSURL *requestTopicURL =[NSURL URLWithString:requestTopicString];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData* data = [NSData dataWithContentsOfURL: requestTopicURL];
        [self performSelectorOnMainThread:@selector(fetchKeywords:) 
                               withObject:data waitUntilDone:YES];
        NSLog(@"complete fetch keyewords");
    });
}


- (void)fetchData:(NSData *)responseData
{
    NSLog(@"topic list: fetch data");
    //parse out the json data,and get user's topics from server
    NSError* error;
    NSArray* json = [NSJSONSerialization JSONObjectWithData:responseData //1
                                                         options:kNilOptions 
                                                           error:&error];
    self.topicList = json;
    [(UITableView*)self.view reloadData];
}


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

    //get topic list of this user_name
    //NSString *accountName = [ZoeTwitterAccount getSharedAccount].account.username;
    NSString *userID = [ZoeTwitterAccount getSharedAccount].twitterID;
    NSString *requestTopicString= [NSString stringWithFormat:@"%@/getuserstopics.php?user_id=%@",TWIZZA_HOST_URL,userID];
    
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
