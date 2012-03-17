//
//  ZoeSuggestCategoryViewController.m
//  Twizza
//
//  Created by Dongmei Hu on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZoeSuggestCategoryViewController.h"

@implementation ZoeSuggestCategoryViewController

@synthesize categoryList;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Data management
- (void)fetchData
{    
    NSURL *url = [NSURL URLWithString:TWITTER_FETCH_SUGGESTION];

    TWRequest *request = [[TWRequest alloc] initWithURL:url 
                                             parameters:nil 
                                          requestMethod:TWRequestMethodGET];
    NSLog(@"Fetch data, account is %@",[ZoeTwitterAccount getSharedAccount].account);
    [request setAccount:[ZoeTwitterAccount getSharedAccount].account];  
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if ([urlResponse statusCode] == 200) {
            NSError *jsonError = nil;
            id jsonResult = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
            
            if (jsonResult != nil) {
                self.categoryList = jsonResult;
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.categoryList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    id catergory = [self.categoryList objectAtIndex:[indexPath row]];
    NSLog(@"row number is %d",[indexPath row]);
    
    //Use viewWithTag to display tweets
    UILabel *cellNameLabel = (UILabel *)[cell viewWithTag:1];
    [cellNameLabel setText:[catergory objectForKey:@"name"]];
    NSLog(@"%@",cellNameLabel.text);
    
    UILabel *cellContentLabel = (UILabel *)[cell viewWithTag:2];
    [cellContentLabel setText:[catergory objectForKey:@"slug"]];
    
    /*
    UIImageView *cellPofileImage = (UIImageView *)[cell viewWithTag:3];
    NSString *imageURLString = [tweet valueForKeyPath:@"user.profile_image_url"];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    NSData *profileImageData = [[NSData alloc] initWithContentsOfURL:imageURL];
    [cellPofileImage setImage:[UIImage imageWithData:profileImageData]];
     */
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark - View lifecycle

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
    NSLog(@"suggest view did load");
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.topItem.title = [[ZoeTwitterAccount getSharedAccount] getUserName];
    [self fetchData];
    [super viewWillAppear:animated];
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
