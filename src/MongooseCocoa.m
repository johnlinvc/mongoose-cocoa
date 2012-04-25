// Copyright (c) 2012 johnlinvc
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MongooseCocoa.h"
void * event_handler(enum mg_event event, struct mg_connection *conn, const struct mg_request_info *request_info);

@implementation MongooseCocoa
@synthesize ctx,delegate;

-(id)initWithDelegate:(id<MongooseCocoaDelegate>) _delegate{
    if([self init]){
        self.delegate = _delegate;
    }
    return self;
}

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
