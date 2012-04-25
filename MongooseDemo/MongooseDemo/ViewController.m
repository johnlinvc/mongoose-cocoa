//
//  ViewController.m
//  MongooseDemo
//
//  Created by  on 12/04/24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "MongooseCocoa.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    MongooseCocoa * httpServer = [[MongooseCocoa alloc] initWithDelegate:self];
    [httpServer start];
}

-(BOOL)onRequestReceived:(enum mg_event)event connection:(struct mg_connection *)conn request:(const struct mg_request_info *)request_info{
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
    return YES;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
