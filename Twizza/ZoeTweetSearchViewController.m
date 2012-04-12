//
//  ZoeTweetSearchViewController.m
//  Twizza
//
//  Created by Dongmei Hu on 2/22/12.
//  Copyright (c) 2012 Z&Z. All rights reserved.
//

#import "ZoeTweetSearchViewController.h"

@interface ZoeTweetSearchViewController(private)
-(void)fetchData;
@end

@implementation ZoeTweetSearchViewController
@synthesize tweetList;
@synthesize topic;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tweetList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    id tweet = [self.tweetList objectAtIndex:indexPath.row];

    //Use viewWithTag to display tweets
    UILabel *cellNameLabel = (UILabel *)[cell viewWithTag:1];
    //[cellNameLabel setText:[tweet valueForKeyPath:@"user.name"]];
    [cellNameLabel setText:[tweet valueForKeyPath:@"from_user_name"]];
    
    UILabel *cellContentLabel = (UILabel *)[cell viewWithTag:2];
    [cellContentLabel setText:[tweet objectForKey:@"text"]];
    
    UIImageView *cellPofileImage = (UIImageView *)[cell viewWithTag:3];
    NSString *imageURLString = [tweet valueForKeyPath:@"profile_image_url"];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    NSData *profileImageData = [[NSData alloc] initWithContentsOfURL:imageURL];
    [cellPofileImage setImage:[UIImage imageWithData:profileImageData]];
    
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%d",((NSArray*)self.tweetList).count);
    
    if (((NSArray*)self.tweetList).count > 0){
        NSDictionary *tweet = [self.tweetList objectAtIndex:[indexPath row]];
        NSString* t = [tweet objectForKey:@"text"];
        return t.length * 1.2 + 20;
    }
    return 140;
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

#pragma mark - View lifecycle

- (void)fetchData
{
    // Do a simple search, using the Twitter API
    NSArray *keywordArray = [self.topic objectForKey:@"topic_keyword"];
    NSString *keywordRaw;
    if (keywordArray.count == 0) {
      keywordRaw = @"";  
    }
    else
    keywordRaw = [keywordArray objectAtIndex:0];
    
    NSArray *sourceArray = [self.topic objectForKey:@"twitter_source"];
    
    for (int i = 1 ; i < keywordArray.count; i++) {
        NSString *trimmedString = [[keywordArray objectAtIndex:i] stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        keywordRaw = [keywordRaw stringByAppendingFormat:@" OR %@",trimmedString];
    }

    for (int i = 0 ; i < sourceArray.count; i++) {
        NSString *trimmedString = [[sourceArray objectAtIndex:i] stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        keywordRaw = [keywordRaw stringByAppendingFormat:@" OR from%@%@",@":",trimmedString];
    }
    
    
    NSString *keywordEncoded = [keywordRaw stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *requestString= [NSString stringWithFormat:@"%@%@&with_twitter_user_id=true&result_type=mixed",TWITTER_SERACH_WITHOUT_Q,keywordEncoded];
    
    TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:
                                                         requestString] 
                                             parameters:nil requestMethod:TWRequestMethodGET];
    
    NSLog(@"URL string is %@",[NSURL URLWithString:
                               requestString]);
    
    [request setAccount:[ZoeTwitterAccount getSharedAccount].account]; 

    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        if ([urlResponse statusCode] == 200) 
        {
            
            NSError *jsonError = nil;
            NSDictionary *jsonResult = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
            if (jsonResult != nil) {
                if (self.tweetList == NULL)
                    self.tweetList = [NSMutableArray arrayWithCapacity:10];
                
                [self.tweetList addObjectsFromArray:[jsonResult objectForKey:@"results"]];

                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });                
            }else {
                NSString *message = [NSString stringWithFormat:@"Could not parse your timeline: %@", [jsonError localizedDescription]];
                [[[UIAlertView alloc] initWithTitle:@"Error" 
                                            message:message
                                           delegate:nil 
                                  cancelButtonTitle:@"Cancel" 
                                  otherButtonTitles:nil] show];
            }
        }else NSLog(@"Twitter error, HTTP response: %i", [urlResponse statusCode]);
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    self.title = [NSString stringWithFormat:@"%@", [self.topic objectForKey:@"topic_name"]];
    [self fetchData];
    [super viewWillAppear:animated];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"view did load");
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"TweetView"]) {        
        NSDictionary *dic = [self.tweetList objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        [ZoeTweet setTweet:dic];
        NSLog(@"%@",dic);
    }
}

@end
