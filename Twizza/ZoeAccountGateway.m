//
//  ZoeAcountGateway.m
//  Twizza
//
//  Created by Dongmei Hu on 3/10/12.
//  Copyright (c) 2012 Z&Z. All rights reserved.
//

#import "ZoeAccountGateway.h"

@interface ZoeAccountGateway()
- (NSDictionary *)getDictionary:(NSString *)fileName;
- (id)readPlist:(NSString *)fileName;
@end

@implementation ZoeAccountGateway

@synthesize accountListVC,timer;


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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


#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


-(void)viewDidAppear:(BOOL)animated{
    NSDictionary *userInfo = [self getDictionary:@"accountList"];
    int i;
    BOOL find = FALSE;
    
    NSArray *aList = self.accountListVC.accounts;
    for (i=0; i<[aList count]; i++) {
        ACAccount *account = [aList objectAtIndex:i];

        if ([[userInfo objectForKey:@"accountName"] isEqualToString:account.username]) {
            [ZoeTwitterAccount setACAccount:account twitterID:[userInfo objectForKey:@"twitterID"]];
            find = TRUE;
            break;
        }
    }
        if (find == TRUE) {
            [self performSegueWithIdentifier:@"ShowTweetListsFromPlist" sender:self];
        }
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

- (IBAction)testMoveView:(id)sender {
    [self performSegueWithIdentifier:@"showtab1" sender:self];
}

@end
