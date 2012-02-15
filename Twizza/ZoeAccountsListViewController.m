//
//  ZoeAccountsListViewController.m
//  Twizza
//
//  Created by Dongmei Hu on 12/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ZoeAccountsListViewController.h"
 

@interface ZoeAccountsListViewController ()
- (void)fetchData;
@property (strong, nonatomic) NSCache *usernameCache;
@property (strong, nonatomic) NSCache *imageCache;
@property (strong, nonatomic) NSCache *userIdCache;
@end

@implementation ZoeAccountsListViewController

@synthesize accounts = _accounts;
@synthesize accountStore = _accountStore;

@synthesize imageCache = _imageCache;
@synthesize usernameCache = _usernameCache;
@synthesize userIdCache = _userIdCache;


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        _imageCache = [[NSCache alloc] init];
        [_imageCache setName:@"TWImageCache"];
        _usernameCache = [[NSCache alloc] init];
        [_usernameCache setName:@"TWUsernameCache"];
        [self fetchData];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [_imageCache removeAllObjects];
    [_usernameCache removeAllObjects];
    [super didReceiveMemoryWarning];
}

#pragma mark - Data handling

- (void)fetchData
{
    //NSLog(@"fetch account");
    if (_accountStore == nil) { 
        //to obtain the account instance for the users twitter account
        self.accountStore = [[ACAccountStore alloc] init];
        if (_accounts == nil) {
            ACAccountType *accountTypeTwitter = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
            //Request access from the user for access to his Twitter accounts
            [self.accountStore requestAccessToAccountsWithType:accountTypeTwitter withCompletionHandler:^(BOOL granted, NSError *error) {
                if(granted) {
                    self.accounts = [self.accountStore accountsWithAccountType:accountTypeTwitter];  
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData]; 
                    });
                }
            }];
        }
    }
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.accounts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"zoeIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    ACAccount *account = [self.accounts objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = account.username;
    cell.detailTextLabel.text = account.accountDescription;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString *username = [_usernameCache objectForKey:account.username];
    if (username) {
        cell.textLabel.text = username;
    }
    else {
        TWRequest *fetchAdvancedUserProperties = [[TWRequest alloc] 
                                                  initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1/users/show.json"] 
                                                  parameters:[NSDictionary dictionaryWithObjectsAndKeys:account.username, @"screen_name", nil]
                                                  requestMethod:TWRequestMethodGET];
        [fetchAdvancedUserProperties performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            if ([urlResponse statusCode] == 200) {
                NSError *error;
                id userInfo = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
                if (userInfo != nil) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [_usernameCache setObject:[userInfo valueForKey:@"name"] forKey:account.username];  
                        [_userIdCache setObject:[userInfo valueForKey:@"id_str"] forKey:account.username];  
                        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:NO];
                    });
                }
            }
        }];        
    }
    
    UIImage *image = [_imageCache objectForKey:account.username];
    if (image) {
        cell.imageView.image = image;        
    }
    else {
        TWRequest *fetchUserImageRequest = [[TWRequest alloc] 
                                            initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.twitter.com/1/users/profile_image/%@", account.username]] 
                                            parameters:nil
                                            requestMethod:TWRequestMethodGET];
        [fetchUserImageRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            if ([urlResponse statusCode] == 200) {
                UIImage *image = [UIImage imageWithData:responseData];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [_imageCache setObject:image forKey:account.username];                    
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:NO];
                });
            }
        }];        
    }
    return cell;
}

-(void)viewDidLoad{
    [super viewDidLoad];
}


#pragma mark - Table view delegate
// Do some customisation of our new view when a table item has been selected
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowTweetLists"]) {
        //set the account 
        [ZoeTwitterAccount setACAccount:[self.accounts objectAtIndex:[[self.tableView indexPathForSelectedRow] row]]];
        
        // Get reference to the destination view controller
        ZoeListViewController *vc = [segue destinationViewController];
        vc.account=[ZoeTwitterAccount getSharedAccount].account;
    }
}

@end
