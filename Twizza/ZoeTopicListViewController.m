//
//  ZoeTopicListViewController.m
//  Twizza
//
//  Created by Dongmei Hu on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "ZoeTopicListViewController.h"

@implementation ZoeTopicListViewController

@synthesize account = _account;
@synthesize topicList = _topicList;

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
    NSLog(@"number of rows %@",self.topicList);
    return [self.topicList count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TopicCellIdentifier";
    NSLog(@"build table");
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *topic = [self.topicList objectAtIndex:[indexPath row]];
    NSLog(@"topic is %@",topic);
    
    UILabel *cellNameLabel = (UILabel *)[cell viewWithTag:2];
    [cellNameLabel setText:topic];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
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

- (void)fetchData:(NSData *)responseData
{
    //parse out the json data,and get user's topics from server
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData //1
                                                         options:kNilOptions 
                                                           error:&error];
    self.topicList = [json objectForKey:@"topic"];
    NSLog(@"%@",self.topicList);
    NSLog(@"topicList count: %d",[self.topicList count]);
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure we're referring to the correct segue
    NSLog(@"segue");
    if ([[segue identifier] isEqualToString:@"AddTopics"]) {        
        ZoeAddTopicViewController *vc;
        vc = [segue destinationViewController];
        
        vc.account = self.account;
    }
    
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    //get topic list of this user_name
    //NSString *user_name = @"zc";
    
    NSString *requestTopicString=@"http://localhost:8888/getuserstopics.php?user_name=zc";
    
    //NSMutableString *requestTopicString = @"http://localhost:8888/getuserstopics.php?user_name=zc";
    //[requestTopicString initWithString:@"http://localhost:8888/getuserstopics.php?user_name=zc"];
    //[requestTopicString appendString:user_name];
    NSLog(@"%@",requestTopicString);
    
    NSURL *requestTopicURL =[NSURL URLWithString:requestTopicString];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData* data = [NSData dataWithContentsOfURL: requestTopicURL];
        [self performSelectorOnMainThread:@selector(fetchData:) 
                               withObject:data waitUntilDone:YES];
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
    self.title = [NSString stringWithFormat:@"%@", self.account.username];
    [super viewWillAppear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
