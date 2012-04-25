//
//  MongooseCocoa.h
//  MongooseDemo
//
//  Created by  on 12/04/24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#include "mongoose.h"

@protocol MongooseCocoaDelegate <NSObject>
@required
-(BOOL)onRequestReceived:(enum mg_event) event connection:(struct mg_connection *) conn request:(const struct mg_request_info *)request_info;

@end

@interface MongooseCocoa : NSObject
@property (nonatomic,assign) struct mg_context *ctx;
@property (nonatomic,assign) id<MongooseCocoaDelegate> delegate;
-(void)start;
-(void)stop;
@end
