//
//  ZoePhotoPickerViewController.h
//  Twizza
//
//  Created by Dongmei Hu on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoePhotoPickerViewController : UIViewController <UIImagePickerControllerDelegate>
{
    UIImageView *imageView;
    //UIImagePickerController *imagePickerController;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton * choosePhoto;

-(IBAction) getPhoto:(id) sender;

@end
