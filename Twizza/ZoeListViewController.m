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

@synthesize timeline = _timeline;

- (void)tweetComposeViewController:(ZoeTweetComposeViewController *)controller didFinishWithResult:(TweetComposeResult)result{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tweets done" message:@"Sent!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
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
    
    NSURL *url = [NSURL URLWithString:TWITTER_FETCH_TIMELINE];
    //json query: https://api.twitter.com/1/statuses/home_timeline.json?include_entities=true
    
    TWRequest *request = [[TWRequest alloc] initWithURL:url 
                                             parameters:param 
                                          requestMethod:TWRequestMethodGET];
    NSLog(@"Fetch data, account is %@",[ZoeTwitterAccount getSharedAccount].account);
    [request setAccount:[ZoeTwitterAccount getSharedAccount].account];  
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if ([urlResponse statusCode] == 200) {
            NSError *jsonError = nil;
            id jsonResult = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
            
            if (jsonResult != nil) {
                self.timeline = jsonResult;
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
        ZoeTweetComposeViewController *vc = [segue destinationViewController];
        vc.tweetComposeDelegate = self;
    }
    
    
    if ([[segue identifier] isEqualToString:@"TweetView"]) {        
        //ZoeTweetViewController *vc = [segue destinationViewController];
               
        NSDictionary *dic = [self.timeline objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        [ZoeTweet setTweet:dic];
        NSLog(@"dic is %@",dic);
        NSLog(@"set zoeTweet user name is %@",[[ZoeTweet getSharedTweet]getUserName]);
    }
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@",TWIZZA_HOST_URL);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.topItem.title = [[ZoeTwitterAccount getSharedAccount] getUserName];
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
    NSLog(@"row number is %d",[indexPath row]);
    
    
    /*
    //Draw frame to make labels within the prototype cell
    UILabel *cellNameLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    [cellNameLabel setFont:[UIFont systemFontOfSize:14]];//textLabel.font = [NTLNStatusCell textFont];
    cellNameLabel.numberOfLines = 10;//max of lines
    [cellNameLabel setText:[tweet valueForKeyPath:@"user.name"]];
    CGRect bounds1 = CGRectMake(0, 0, 256, 300.0);
    CGRect result1 = [cellNameLabel textRectForBounds:bounds1 limitedToNumberOfLines:10];
    [cell addSubview:cellNameLabel];
    
    UILabel *cellContentLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    [cellContentLabel setFont:[UIFont systemFontOfSize:14]];//textLabel.font = [NTLNStatusCell textFont];
    cellContentLabel.numberOfLines = 10;//max of lines
    [cellContentLabel setText:[tweet objectForKey:@"text"]];
    CGRect bounds2 = CGRectMake(0, 10, 256, 300.0);
    CGRect result2 = [cellContentLabel textRectForBounds:bounds2 limitedToNumberOfLines:10];
	CGFloat h = result2.size.height;//Get text box height
    NSLog(@"height is %@",h);
    [cell addSubview:cellContentLabel];

    
    
    UILabel *cellContentLabel = [[UILabel alloc] initWithFrame: CGRectMake(60, 50, 260, 50)];
    [cellContentLabel setFont:[UIFont systemFontOfSize:14]];//textLabel.font = [NTLNStatusCell textFont];
    cellContentLabel.numberOfLines = 5;//max of lines
    [cellContentLabel setMinimumFontSize:10];
    [cellContentLabel setText:[tweet objectForKey:@"text"]];
    [cell addSubview:cellContentLabel];
    //[cellContentLabel setText:[tweet valueForKeyPath:@"user.profile_image_url"]];*/
    
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
