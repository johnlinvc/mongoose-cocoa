//
//  MongooseCocoa.h
//  MongooseDemo
//
//  Created by  on 12/04/24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "mongoose.h"
@interface MongooseCocoa : NSObject
@property (nonatomic,assign) struct mg_context *ctx;
-(void)start;
-(void)stop;
@end
