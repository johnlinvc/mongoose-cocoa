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
@synthesize ctx;
-(void)start{
    const char * options[] = {
        "listening_ports","8880",NULL
    };
    ctx = mg_start(&event_handler, NULL, options);
}


@end
void * event_handler(enum mg_event event, struct mg_connection *conn, const struct mg_request_info *request_info){
    static void* done = "done";
    char* content = "Hello World!";
    char* mimeType = "text/plain";
    int contentLength = strlen(content);
    
    mg_printf(conn,
              "HTTP/1.1 200 OK\r\n"
              "Cache: no-cache\r\n"
              "Content-Type: %s\r\n"
              "Content-Length: %d\r\n"
              "\r\n",
              mimeType,
              contentLength);
    mg_write(conn, content, contentLength);
    return done;
}