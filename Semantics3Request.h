//
//  Semantics3Request.h
//  openlabel
//
//  Created by David Ng on 3/28/13.
//  Copyright (c) 2013 Scandipity Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthConsumer.h"
#import "OAToken.h"

typedef void (^S3CallbackBlock)(BOOL success, NSDictionary *results);

@interface Semantics3Request : NSObject


+ (Semantics3Request*) setupWithKey:(NSString*)key secret:(NSString*)secret;
- (void) fetchResource:(NSString*)url_string withBlock:(S3CallbackBlock)callback;

@end
