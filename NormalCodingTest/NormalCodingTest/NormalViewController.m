//
//  NormalViewController.m
//  NormalCodingTest
//
//  Created by Shaun Salzberg on 2/24/14.
//  Copyright (c) 2014 Shaun Salzberg. All rights reserved.
//

#import "NormalViewController.h"
#import "NormalCameraHandler.h"

@interface NormalViewController ()

@end

@implementation NormalViewController

NormalCameraHandler *cameraHandler;

@synthesize takePictureBtn;
@synthesize modelImageView;
@synthesize spinner;
@synthesize pleaseWaitNotice;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // hide the modelImageView, spinner, and pleaseWaitNotice
    [modelImageView setHidden:YES];
    [spinner setHidden:YES];
    [pleaseWaitNotice setHidden:YES];
    
    // initialize camera handler with self as delegate
    cameraHandler = [[NormalCameraHandler alloc] initWithViewController:self];
    
    // move takePictureBtn to bottom of screen, regardless of screen size
    [takePictureBtn setFrame:CGRectMake(takePictureBtn.frame.origin.x, self.view.frame.size.height - takePictureBtn.frame.size.height - 50, takePictureBtn.frame.size.width, takePictureBtn.frame.size.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onTakePictureBtnTouched:(UIButton *)sender {
    BOOL res = [cameraHandler openCamera];
    
    if(!res)
        [self displayError:@"Whoops, we had some trouble opening your camera."];
}

- (void) uploadImageDidBegin {
    [self showLoading:YES];
    [modelImageView setHidden:YES];
}

- (void) uploadImageDidFinishWithSuccess:(BOOL)success modelUrl:(NSString *)modelUrl {
    if(!success) {
        [self showLoading:NO];
        [self displayError:@"Whoops, looks like we had some trouble generating your model. Please try again in moment."];
        return;
    }
    
    // load and display the model image
    NSURL *imageURL = [NSURL URLWithString:modelUrl];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLoading:NO];
            modelImageView.image = [UIImage imageWithData:imageData];
            [modelImageView setHidden:NO];
        });
    });
}

- (void) showLoading:(BOOL)show {
    dispatch_async(dispatch_get_main_queue(), ^{
        [spinner setHidden:!show];
        [pleaseWaitNotice setHidden:!show];
    });
}

- (void) displayError:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    });
}



@end
