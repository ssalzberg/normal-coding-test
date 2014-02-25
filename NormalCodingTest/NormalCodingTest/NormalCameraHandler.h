//
//  NormalCameraHandler.h
//  NormalCodingTest
//
//  Created by Shaun Salzberg on 2/24/14.
//  Copyright (c) 2014 Shaun Salzberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NormalApi.h"

@interface NormalCameraHandler : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (NormalCameraHandler *) initWithViewController:(UIViewController<NormalApiDelegate> *)controller;
- (BOOL) openCamera;


@end
