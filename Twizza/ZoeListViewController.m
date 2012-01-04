//
//  ZoeListViewController.m
//  Twizza
//
//  Created by Dongmei Hu on 12/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ZoeListViewController.h"

@interface ZoeListViewController(private)
- (void)fetchData;
@end

@interface UILabel (BPExtensions)
- (void)sizeToFitFixedWidth:(CGFloat)fixedWidth;
@end


@implementation UILabel (BPExtensions)
- (void)sizeToFitFixedWidth:(CGFloat)fixedWidth
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, fixedWidth, 20);
    self.lineBreakMode = UILineBreakModeWordWrap;
    self.numberOfLines = 0;
    //[self sizeToFit];
}
@end

@implementation ZoeListViewController

@synthesize account = _account;
@synthesize timeline = _timeline;

/*
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}*/

- (void)tweetComposeViewController:(ZoeTweetComposeViewController *)controller didFinishWithResult:(TweetComposeResult)result{
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Data management

- (void)fetchData
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:@"1" forKey:@"include_entities"];//get all entities for each tweet
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/home_timeline.json"];
    TWRequest *request = [[TWRequest alloc] initWithURL:url 
                                             parameters:param 
                                          requestMethod:TWRequestMethodGET];
    [request setAccount:self.account];    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if ([urlResponse statusCode] == 200) {
            NSError *jsonError = nil;
            id jsonResult = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
            
            if (jsonResult != nil) {
                self.timeline = jsonResult;
                
                NSArray *arr = (NSArray*)self.timeline;
                NSDictionary *dict = [arr objectAtIndex:0];
                for (NSString *k in [dict allKeys]){
                    //NSLog(@"%@",k);
                }
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });                
            }
            else {
                NSString *message = [NSString stringWithFormat:@"Could not parse your timeline: %@", [jsonError localizedDescription]];
                [[[UIAlertView alloc] initWithTitle:@"Error" 
                                            message:message
                                           delegate:nil 
                                  cancelButtonTitle:@"Cancel" 
                                  otherButtonTitles:nil] show];
            }
        }
    }];
    
}


 #pragma mark - Compose Tweet

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure we're referring to the correct segue
    if ([[segue identifier] isEqualToString:@"ComposeTweet"]) {
        
        // Get reference to the destination view controller
        ZoeTweetComposeViewController *vc;
        vc = [segue destinationViewController];
        
        //NSLog(@"List View Controller, self.account is %@", self.account);
        vc.account = self.account;
        vc.tweetComposeDelegate = self;
    }
}

/*
- (void)composeTweet
{
    TWTweetComposeViewController *tweetComposeViewController = [[TWTweetComposeViewController alloc] init];
    [tweetComposeViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        [self dismissModalViewControllerAnimated:YES];
    }];
    [self presentModalViewController:tweetComposeViewController animated:YES];
}

- (void)tweetComposeViewController:(ZoeTweetComposeViewController *)controller didFinishWithResult:(TweetComposeResult)result {
    [self dismissModalViewControllerAnimated:YES];
    [self fetchData];
}
*/

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    /*UIBarButtonItem *compose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose 
                                                                             target:self 
                                                                             action:@selector(composeTweet)];
     */
    /*UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
                                                                             target:self 
                                                                             action:@selector(fetchData)];
     */
    //self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:compose, nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.title = [NSString stringWithFormat:@"@%@", self.account.username];
    [self fetchData];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.timeline count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    id tweet = [self.timeline objectAtIndex:[indexPath row]];
    
    /*
    if (cell != nil){
        NSLog(@"nt nil");
    }*/
    
    
    /** Draw frame to make labels within the prototype cell
    UILabel *cellNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(60, 0, 260, 50)];
    [cell addSubview:cellNameLabel];
    [cellNameLabel setFont:[UIFont systemFontOfSize:14]];//textLabel.font = [NTLNStatusCell textFont];
    cellNameLabel.numberOfLines = 1;//max of lines
    [cellNameLabel setText:[tweet valueForKeyPath:@"user.name"]];
    
    UILabel *cellContentLabel = [[UILabel alloc] initWithFrame: CGRectMake(60, 50, 260, 50)];
    [cell addSubview:cellContentLabel];
    [cellContentLabel setFont:[UIFont systemFontOfSize:14]];//textLabel.font = [NTLNStatusCell textFont];
    cellContentLabel.numberOfLines = 5;//max of lines
    [cellContentLabel setMinimumFontSize:10];
    [cellContentLabel setText:[tweet objectForKey:@"text"]];
    //[cellContentLabel setText:[tweet valueForKeyPath:@"user.profile_image_url"]];
     */
    
    //Use viewWithTag to display tweets
    UILabel *cellNameLabel = (UILabel *)[cell viewWithTag:1];
    [cellNameLabel setText:[tweet valueForKeyPath:@"user.name"]];
    
    UILabel *cellContentLabel = (UILabel *)[cell viewWithTag:2];
    [cellContentLabel setText:[tweet objectForKey:@"text"]];

    UIImageView *cellPofileImage = (UIImageView *)[cell viewWithTag:3];
    NSString *imageURLString = [tweet valueForKeyPath:@"user.profile_image_url"];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    NSData *profileImageData = [[NSData alloc] initWithContentsOfURL:imageURL];
    [cellPofileImage setImage:[UIImage imageWithData:profileImageData]];
    
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

@end
