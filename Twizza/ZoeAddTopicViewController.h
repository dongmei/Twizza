//
//  ZoeAddTopicViewController.h
//  Twizza
//
//  Created by Dongmei Hu on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>

@interface ZoeAddTopicViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *addedTopic;
@property (strong, nonatomic) ACAccount *account;

-(IBAction)addNewTopic:(id) sender;

@end
