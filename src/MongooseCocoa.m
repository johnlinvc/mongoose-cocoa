//
//  MongooseCocoa.m
//  MongooseDemo
//
//  Created by  on 12/04/24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MongooseCocoa.h"
void * event_handler(enum mg_event event, struct mg_connection *conn, const struct mg_request_info *request_info);

@implementation MongooseCocoa
@synthesize ctx,delegate;
-(void)start{
    const char * options[] = {
        "listening_ports","8880",NULL
    };
    ctx = mg_start(&event_handler, self, options);
}

-(void)stop{
    mg_stop(ctx);
}


@end
void * event_handler(enum mg_event event, struct mg_connection *conn, const struct mg_request_info *request_info){
    MongooseCocoa * THIS = request_info->user_data;
    BOOL processed = NO;
    if (THIS.delegate!=nil) {
        processed = [THIS.delegate onRequestReceived:event connection:conn request:request_info];
    }
    static void* done = "done";    
    if (processed) {
        return done;
    } else {
        return NULL;
    }
}
