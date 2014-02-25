//
//  NormalApi.h
//  NormalCodingTest
//
//  Created by Shaun Salzberg on 2/24/14.
//  Copyright (c) 2014 Shaun Salzberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NormalApiDelegate <NSObject>
- (void) uploadImageDidBegin;
- (void) uploadImageDidFinishWithSuccess:(BOOL)success modelUrl:(NSString *)modelUrl;
@end

@interface NormalApi : NSObject

- (NormalApi *) initWithDelegate:(id<NormalApiDelegate>)delegate;
- (void) uploadImage:(UIImage *)image;

@end
