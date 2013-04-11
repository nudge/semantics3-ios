//
//  Semantics3Request.m
//  openlabel
//
//  Created by David Ng on 3/28/13.
//  Copyright (c) 2013 Scandipity Inc. All rights reserved.
//

#import "Semantics3Request.h"
#import "SBJsonParser.h"

static NSString* kApiDomain = @"api.semantics3.com";
static NSString* kApiBaseFormat = @"https://%@/v1/";


@interface Semantics3Request () {
    S3CallbackBlock _callback;
}
    @property (nonatomic, copy) NSString* key;
    @property (nonatomic, copy) NSString* secret;
    @property (nonatomic, retain) NSString* baseUrl;
    @property (nonatomic, retain) OAConsumer* consumer;
    @property (nonatomic, retain) OAToken* token;
@end

@implementation Semantics3Request

    + (Semantics3Request*) setupWithKey:(NSString*)key secret:(NSString*)secret
    {
        Semantics3Request* s3req = [[Semantics3Request alloc] init];
        s3req.key = key;
        s3req.secret = secret;
        s3req.consumer = [[OAConsumer alloc] initWithKey:key secret:secret];
        s3req.token = [[OAToken alloc] initWithKey:@"" secret:@""];
        s3req.baseUrl = [NSString stringWithFormat:kApiBaseFormat, kApiDomain];
        
        return s3req;
    }

    - (void) fetchResource:(NSString*)url_string withBlock:(S3CallbackBlock)callback
    {
        NSString* stringUrl = [[self.baseUrl stringByAppendingString:url_string]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:stringUrl];

        NSLog(@"url: %@",[url description]);
        
        OAMutableURLRequest *request = [[OAMutableURLRequest alloc]
                                        initWithURL:url
                                        consumer:_consumer
                                        token:_token
                                        realm:nil
                                        signatureProvider:nil]; // use the default method, HMAC-SHA1
        
        [request setHTTPMethod:@"GET"];
        
        OADataFetcher *fetcher = [[OADataFetcher alloc] init];
        
        _callback = callback;
        
        [fetcher fetchDataWithRequest:request
                             delegate:self
                    didFinishSelector:@selector(requestDidFinishWithTicket:data:)
                      didFailSelector:@selector(requestDidFailWithTicket:error:)];
    }

- (void) requestDidFinishWithTicket:(OAServiceTicket*)ticket data:(NSMutableData*)data
{
    NSMutableDictionary *returnedData = [[[SBJsonParser alloc] init] objectWithData:data];
    if (_callback) _callback(YES, returnedData);
}

- (void) requestDidFailWithTicket:(OAServiceTicket*)ticket error:(NSError*)error
{
    NSLog(@"request:didFailWithError: %@", ticket);
    NSLog(@"request:didFailWithError: %@", error);
    
    if (_callback) _callback(NO, nil);
}



@end

