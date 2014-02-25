//
//  NormalViewController.h
//  NormalCodingTest
//
//  Created by Shaun Salzberg on 2/24/14.
//  Copyright (c) 2014 Shaun Salzberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NormalApi.h"

@interface NormalViewController : UIViewController <NormalApiDelegate>

@property (weak, nonatomic) IBOutlet UIButton *takePictureBtn;
@property (weak, nonatomic) IBOutlet UIImageView *modelImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UITextView *pleaseWaitNotice;

@end
