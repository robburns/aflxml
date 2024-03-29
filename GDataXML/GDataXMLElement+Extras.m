//
//  GDataXMLElement+Extras.m
//  WSBA
//
//  Created by Rob Burns on 14/12/11.
//  Copyright (c) 2011 4 Cain Ct Altona VIC 3018. All rights reserved.
//

#import "GDataXMLElement+Extras.h"

@implementation GDataXMLElement(Extras)

- (GDataXMLElement *)elementForChild:(NSString *)childName {
    NSArray *children = [self elementsForName:childName];            
    if (children.count > 0) {
        GDataXMLElement *childElement = (GDataXMLElement *) [children objectAtIndex:0];
        return childElement;
    } else return nil;
}

- (NSString *)valueForChild:(NSString *)childName {    
    return [[self elementForChild:childName] stringValue];    
}

@end
