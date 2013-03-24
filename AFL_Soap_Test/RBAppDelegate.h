//
//  RBAppDelegate.h
//  AFL_Soap_Test
//
//  Created by Robert Burns on 20/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface RBAppDelegate : NSObject <NSApplicationDelegate, NSXMLParserDelegate >{
    IBOutlet NSTextView *text;
    //---web service access---
    NSMutableData *webData;
    NSMutableString *soapResults;
    NSURLConnection *conn;
    //---xml parsing---
    NSXMLParser *xmlParser;
    BOOL elementFound;
    NSMutableArray *parent;
    NSMutableString *textString;
}



@property (assign) IBOutlet NSWindow *window;

@end
