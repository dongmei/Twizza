//
//  ZoeAddTopicViewController.h
//  Twizza
//
//  Created by Dongmei Hu on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import "ZoeTwitterAccount.h"
#import "constants.h"

@interface ZoeAddTopicViewController : UIViewController
{
        NSURLConnection * _connection;
}

@property (strong, nonatomic) IBOutlet UITextField *addedTopic;
@property (nonatomic, retain) NSURLConnection * connection; 

-(IBAction)addNewTopic:(id) sender;

@end
