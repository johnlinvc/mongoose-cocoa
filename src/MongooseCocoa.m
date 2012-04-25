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
    NSArray * option = [NSArray arrayWithObjects:@"listening_ports",@"8880", nil];
    [self startWithOption:option];
}


-(void)startWithOption:(NSArray *)option{
    int count = option.count;
    const char ** mg_option = malloc(sizeof(char*) * count +1); 
    [option enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString * s = (NSString*) obj;
        const char * cs = [s cStringUsingEncoding:NSUTF8StringEncoding];
        int len = strlen(cs);
        char * cpy = (char*)malloc(sizeof(char)*(len+1));
        strncpy(cpy, cs, len);
        mg_option[idx] =  cpy;
    }];
    mg_option[count] = NULL;
    ctx = mg_start(&event_handler, self, mg_option);
    for (int i=0; i<count; i++) {
        free((void*)mg_option[i]);
    }
    free(mg_option);
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
