//
//  NormalApi.m
//  NormalCodingTest
//
//  Created by Shaun Salzberg on 2/24/14.
//  Copyright (c) 2014 Shaun Salzberg. All rights reserved.
//

#import "NormalApi.h"

@implementation NormalApi

NSString *POST_BOUNDARY = @"----------normal-api";
NSString *IMAGE_FILE_PARAM = @"file";

NSString *API_HOST = @"192.168.1.3:3000";
NSString *UPLOAD_PATH = @"/upload.json";

NSString *SUCCESS_KEY = @"success";
NSString *MODEL_URL_KEY = @"model_url";

id<NormalApiDelegate> apiDelegate;

- (NormalApi *)initWithDelegate:(id<NormalApiDelegate>)delegate {
    self = [self init];
    apiDelegate = delegate;
    return self;
}

- (void) uploadImage:(UIImage *)image {
    [apiDelegate uploadImageDidBegin];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    if(!imageData) {
        [apiDelegate uploadImageDidFinishWithSuccess:NO modelUrl:nil];
        return;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", POST_BOUNDARY];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];

    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", POST_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpeg\"\r\n", IMAGE_FILE_PARAM] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", POST_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", (int)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setURL:[self uploadImageUrl]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if ([data length] > 0 && error == nil) {
            NSMutableDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            NSString *successString = (NSString *)[jsonResponse valueForKey:SUCCESS_KEY];
            BOOL success = [successString isEqualToString:@"true"];
            
            NSString *modelUrl = nil;
            
            if(success)
                modelUrl = (NSString *)[jsonResponse valueForKey:MODEL_URL_KEY];

            [apiDelegate uploadImageDidFinishWithSuccess:success modelUrl:modelUrl];
        } else if ([data length] == 0 && error == nil)
            [apiDelegate uploadImageDidFinishWithSuccess:NO modelUrl:nil];
        else if (error != nil && error.code == NSURLErrorTimedOut)
            [apiDelegate uploadImageDidFinishWithSuccess:NO modelUrl:nil];
        else if (error != nil)
            [apiDelegate uploadImageDidFinishWithSuccess:NO modelUrl:nil];
    }];
}

- (NSURL *) uploadImageUrl {
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@",API_HOST,UPLOAD_PATH]];
}

@end
