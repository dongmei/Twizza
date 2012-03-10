//
//  ZoeAcountGateway.h
//  Twizza
//
//  Created by Dongmei Hu on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoeAccountsListViewController.h"

@interface ZoeAccountGateway : UIViewController

{
    ZoeAccountsListViewController *cvc;
}

@property(strong,nonatomic)IBOutlet ZoeAccountsListViewController *accountListVC;

- (IBAction)testMoveView:(id)sender;

@end
