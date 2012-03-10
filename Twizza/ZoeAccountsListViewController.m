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
- (NSDictionary *)getDictionary:(NSString *)fileName;
- (id)readPlist:(NSString *)fileName;

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
    
    //[self performSegueWithIdentifier:@"ShowTweetLists" sender:self];
    if (self){
        _imageCache = [[NSCache alloc] init];
        [_imageCache setName:@"TWImageCache"];
        _usernameCache = [[NSCache alloc] init];
        [_usernameCache setName:@"TWUserIDCache"];
        _userIdCache = [[NSCache alloc] init];
        [_userIdCache setName:@"TWUserIDCache"];
        [self fetchData];
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    [_imageCache removeAllObjects];
    [_usernameCache removeAllObjects];
    NSLog(@"memorywarning");
    [_userIdCache removeAllObjects];
    [super didReceiveMemoryWarning];
}


#pragma mark - pList
- (id)readPlist:(NSString *)fileName {  
    NSData *plistData;  
    NSString *error;  
    NSPropertyListFormat format;  
    id plist;  
    
    NSString *localizedPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];  
    plistData = [NSData dataWithContentsOfFile:localizedPath];   
    
    plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];  
    if (!plist) {  
        NSLog(@"Error reading plist from file '%s', error = '%s'", [localizedPath UTF8String], [error UTF8String]);  
    }  
    
    return plist;  
} 

- (NSDictionary *)getDictionary:(NSString *)fileName {  
    return (NSDictionary *)[self readPlist:fileName];  
} 

#pragma mark - Data handling
- (void)fetchData
{
    if (_accountStore == nil) { 
        //to obtain the account instance for the users twitter account
        self.accountStore = [[ACAccountStore alloc] init];
        if (_accounts == nil) {
            ACAccountType *accountTypeTwitter = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
            //Request access from the user for access to his Twitter accounts
            [self.accountStore requestAccessToAccountsWithType:accountTypeTwitter withCompletionHandler:^(BOOL granted, NSError *error) {
                if(granted) {
                    self.accounts = [self.accountStore accountsWithAccountType:accountTypeTwitter];  
                    //NSLog(@"account is %@",[self.accounts objectAtIndex:0]);
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


-(void)viewDidLoad{
    [super viewDidLoad];
    [self checkForWIFIConnection];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*
    //check pList
    NSDictionary *userInfo = [self getDictionary:@"accountList"];
    int i;
    
    [self performSegueWithIdentifier:@"ShowMask" sender:self];
    
    for (i=0; i<[self.accountStore.accounts count]; i++) {
        ACAccount *account = [self.accountStore.accounts objectAtIndex:i];
        NSLog(@"%@",account.username);
        NSLog(@"%@",[userInfo objectForKey:@"accountName"]);
        if ([[userInfo objectForKey:@"accountName"] isEqualToString:account.username]) {
            [ZoeTwitterAccount setACAccount:account twitterID:[userInfo objectForKey:@"twitterID"]];
            NSLog(@"change view");
            [self performSegueWithIdentifier:@"ShowTweetListsFromPlist" sender:self];
        }
    }*/
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
                                                  initWithURL:[NSURL URLWithString:TWITTER_FETCH_ACCOUNT_DATA] 
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
            }else {
                NSLog(@"Twitter error, HTTP response: %i", [urlResponse statusCode]);
            }
        }];        
    }
    
    UIImage *image = [_imageCache objectForKey:account.username];
    if (image) {
        cell.imageView.image = image;        
    }
    else {
        TWRequest *fetchUserImageRequest = [[TWRequest alloc] 
                                            initWithURL:[NSURL URLWithString:[NSString stringWithFormat:TWITTER_FETCH_PROFILE_IMAGE, account.username]] 
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


//Check Wifi connection
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


#pragma mark - Table view delegate
// Do some customisation of our new view when a table item has been selected
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"ShowTweetLists"]) {
        //set the account 
        ACAccount *account = [self.accounts objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        NSString *tID = [_userIdCache objectForKey:account.username];
        NSLog(@"twitter id is %@",_userIdCache);
        [ZoeTwitterAccount setACAccount:account twitterID:tID];
        //[ZoeTwitterAccount setACAccount:account twitterID:@"71209705"];
    }
    
    if ([[segue identifier] isEqualToString:@"ShowTweetListsFromPlist"]) {
        //set the account 
        NSLog(@" ShowTweetListsFromPlist");
    }
}

@end
