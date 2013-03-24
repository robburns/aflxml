//
//  GDataXMLElement+Extras.h
//  WSBA
//
//  Created by Rob Burns on 14/12/11.
//  Copyright (c) 2011 4 Cain Ct Altona VIC 3018. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface GDataXMLElement (Extras)

- (GDataXMLElement *)elementForChild:(NSString *)childName;
- (NSString *)valueForChild:(NSString *)childName;

@end