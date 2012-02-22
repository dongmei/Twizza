//
//  ZoeTweetSearchViewController.m
//  Twizza
//
//  Created by Dongmei Hu on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZoeTweetSearchViewController.h"

@interface ZoeTweetSearchViewController(private)
-(void)fetchData;
@end

@implementation ZoeTweetSearchViewController
@synthesize tweetList = _tweetList;

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
    
    id tweets = [self.tweetList objectForKey:@"results"];
    id tweet = [tweets objectAtIndex:indexPath.row];
    
    //id tweet = [self.tweetList objectAtIndex:[indexPath row]];
    
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

#pragma mark - View lifecycle

- (void)fetchData
{
    // Do a simple search, using the Twitter API
    NSLog(@"fetch data");

    NSString *keyword = @"iOS%205";
    NSString *requestString= [NSString stringWithFormat:@"%@%@&with_twitter_user_id=true&result_type=recent",TWITTER_SERACH_WITHOUT_Q,keyword];
    
    TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:
                                                         requestString] 
                                             parameters:nil requestMethod:TWRequestMethodGET];
    [request setAccount:[ZoeTwitterAccount getSharedAccount].account]; 

    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        if ([urlResponse statusCode] == 200) 
        {
            
            NSError *jsonError = nil;
            
            
            id jsonResult = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];

            if (jsonResult != nil) {
                self.tweetList = jsonResult;
                NSLog(@"Twitter response: %@", jsonResult); 
                
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
    self.title = [NSString stringWithFormat:@"@%@", [ZoeTwitterAccount getSharedAccount].account.username];
    [self fetchData];
    [super viewWillAppear:animated];
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


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

@end
