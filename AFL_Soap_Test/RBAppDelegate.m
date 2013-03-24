//
//  RBAppDelegate.m
//  AFL_Soap_Test
//
//  Created by Robert Burns on 20/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//  This programme can be used to obtain info about the various types AFL Soap data.
//  The available soap data is outlined at the web address 
//   http://xml.afl.com.au/mobilewebservices.asmx
//
//  There are two parts of the programme that need to be changed according to the type
//  of data required.
// (1) The fields between the two SoapBody statements:
/// "<soap:Body>"
/// ....
//// "</soap:Body>"
//// Any required variables need to be coded after the "</soap:Envelope>" statement
///
///  (2) The [req addValue: ... forHTTPHeaderField:@"SOAPAction"]; needs to be filled in
///  with the desired soap info, e.g. [req addValue:@"http://xml.afl.com.au/
///  GetSportSeasonsByCompetition" forHTTPHeaderField:@"SOAPAction"];


#import "RBAppDelegate.h"
#import "GDataXMLNode.h"
#import "GDataXMLElement+Extras.h"

@implementation RBAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
//    NSLog(@"init");
    if (self) {
        // Add your subclass-specific initialization here.
        // If an error occurs here, return nil.
//        textString = [[NSMutableString alloc] initWithString:@""]; 
/*        NSString *soapMsg =
        [NSString stringWithFormat:
         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
         "<soap:Body>"
         "<SportSeasonsByCompetitionRequest xmlns=\"http://xml.afl.com.au\">"
         "<CompetitionId>%d</CompetitionId>"
         "</SportSeasonsByCompetitionRequest>"
        "</soap:Body>"
         "</soap:Envelope>", 1
 */
/*         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
         "<soap:Body>"
         "<SportRoundsBySeasonRequest xmlns=\"http://xml.afl.com.au\">"
         "<SeasonId>%d</SeasonId>"
         "</SportRoundsBySeasonRequest>"
         "</soap:Body>"
         "</soap:Envelope>", 109 ];
*/
/*        NSString *soapMsg =
        [NSString stringWithFormat:
         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
         "<soap:Body>"
         "<RankingBySeasonRequest xmlns=\"http://xml.afl.com.au\">"
         "<SeasonId>%d</SeasonId>"
         "<NumberOfRecordsPerCategory>%d</NumberOfRecordsPerCategory>"
         "</RankingBySeasonRequest>"
         "</soap:Body>"
         "</soap:Envelope>", 8, 25
         ];
*/
        NSString *soapMsg =
        [NSString stringWithFormat:
         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
         "<soap:Body>"
//         "<RankingBySeasonRequest xmlns=\"http://xml.afl.com.au\">"
//         "<SeasonId>%d</SeasonId>"
//         "<NumberOfRecordsPerCategory>%d</NumberOfRecordsPerCategory>"
//         "</RankingBySeasonRequest>"
         "<SportRoundsBySeasonRequest xmlns=\"http://xml.afl.com.au\">"
         "<SeasonId>115</SeasonId>"
         "</SportRoundsBySeasonRequest>"
         
//         "<CurrentSportRoundBySeasonRequest xmlns=\"http://xml.afl.com.au\">"
//         "<SeasonId>115</SeasonId>"
//         "</CurrentSportRoundBySeasonRequest>"

         "</soap:Body>"
         "</soap:Envelope>"
         ];

        
        NSURL *url = [NSURL URLWithString:
                      @"http://xml.afl.com.au/mobilewebservices.asmx"];
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
        //---set the headers---
        NSString *msgLength = [NSString stringWithFormat:@"%ld",
                               [soapMsg length]];
        [req addValue:@"text/xml; charset=utf-8"
   forHTTPHeaderField:@"Content-Type"];
        [req addValue:@"http://xml.afl.com.au/GetSportRoundsBySeason" forHTTPHeaderField:@"SOAPAction"];
        
        [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
        //---set the HTTP method and body---
        [req setHTTPMethod:@"POST"];
        [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
        //    [activityIndicator startAnimating];
        conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
        if (conn) {
//            NSLog(@"conn");
            webData = [NSMutableData data];
        }
    }
}

-(void) connection:(NSURLConnection *) connection
didReceiveResponse:(NSURLResponse *) response {
    [webData setLength: 0];
//    NSLog(@"connection didReceiveResponse");
}

-(void) connection:(NSURLConnection *) connection
    didReceiveData:(NSData *) data {
    [webData appendData:data];
//    NSLog(@"connection didReceiveData");
}

-(void) connection:(NSURLConnection *) connection
  didFailWithError:(NSError *) error {
    NSLog(@"connection didFailWithError %@", error);
}

-(void) connectionDidFinishLoading:(NSURLConnection *) connection {    
    parent = [[NSMutableArray alloc]initWithCapacity:50];
    
    xmlParser = [[NSXMLParser alloc] initWithData: webData];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
}

//---when the start of an element is found---
-(void) parser:(NSXMLParser *) parser
didStartElement:(NSString *) elementName
  namespaceURI:(NSString *) namespaceURI
 qualifiedName:(NSString *) qName
    attributes:(NSDictionary *) attributeDict {
//    NSLog(@"parser didStartElement");
    if (!soapResults)
    {
        soapResults = [[NSMutableString alloc] init];
    }
    elementFound = YES; 
    //    NSLog(@"element found %@", elementName);
    
    [parent addObject:elementName];
}

// The next method to implement is parser:foundCharacters:, which gets fired when the parser finds the text of an element:

-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
//    NSLog(@"parser foundChars");
    if (elementFound)
    {
        [soapResults appendString: string];
//        NSLog(@"elementFound");
    }
}

//---when the end of element is found---
-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    //    NSLog(@"removed parent %@", [parent lastObject]);
    [parent removeLastObject];
    NSString *temp = [[NSString alloc] initWithFormat:@"elementName is %@ and element is %@\n", elementName, soapResults];
    NSLog(@"%@", temp);
    
    [textString appendString:temp];
    [text insertText:temp];
    
    [soapResults setString:@""];
    elementFound = FALSE;
}

@end
