//
//  ZoeAcountGateway.h
//  Twizza
//
//  Created by Dongmei Hu on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoeAccountsListViewController.h"
#import "ZoeTwitterAccount.h"

@interface ZoeAccountGateway : UIViewController
{
    ZoeAccountsListViewController *accountListVC;
}

@property(strong,nonatomic)IBOutlet ZoeAccountsListViewController *accountListVC;

@property(strong,nonatomic)NSTimer*  timer;


@end
