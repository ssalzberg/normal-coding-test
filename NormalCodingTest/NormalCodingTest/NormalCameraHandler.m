//
//  NormalCameraHandler.h
//  NormalCodingTest
//
//  Created by Shaun Salzberg on 2/24/14.
//  Copyright (c) 2014 Shaun Salzberg. All rights reserved.
//

#import "NormalCameraHandler.h"
#import "NormalApi.h"

@implementation NormalCameraHandler

UIViewController *parentViewController;
NormalApi *normalApi;

- (NormalCameraHandler *) initWithViewController:(UIViewController<NormalApiDelegate> *)controller {
    self = [self init];
    
    parentViewController = controller;
    normalApi = [[NormalApi alloc] initWithDelegate:parentViewController];
    
    return self;
}

- (BOOL) openCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return NO;
    }
    
    // open camera only with the ability to take a single photo with no editing
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = self;
    
    [parentViewController presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
}

// close the camera if the user cancelled
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    [parentViewController dismissViewControllerAnimated:YES completion:nil];
}

// the image has been selected by the user, so upload it
- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    UIImage *theImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        
    [normalApi uploadImage:theImage];
    
    [parentViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
