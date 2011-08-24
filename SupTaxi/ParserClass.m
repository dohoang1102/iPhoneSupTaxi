//
//  ParserClass.m
//  SupTaxi
//
//  Created by naceka on 19.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ParserClass.h"
#import "Response.h"
#import "Offer.h"
#import "GDataXMLNode.h"

@implementation ParserClass

+ (Response *)loadResponseWithData:(NSData *)xmlData
{
    NSError *error;
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (doc == nil) {
        return nil;
    }
    
    
    NSLog(@"Document root element: %@", doc.rootElement);
    
    Response *response = [[[Response alloc] init] autorelease];
    
    NSArray *responseMembers = [doc.rootElement elementsForName:@"Offer"];
    
    for (GDataXMLElement *responseMember in responseMembers) 
    {        
        NSString *name;
        int time;
        int price;
        
        GDataXMLNode *node; 
        
        // company name
        node = [responseMember attributeForName:@"CarrierName"];
        name = [[NSString alloc] initWithString:[node stringValue]];
        
        // arrival time
        node = [responseMember attributeForName:@"ArrivalTime"];
        time = [[node stringValue] intValue];
        
        // minimal price
        node = [responseMember attributeForName:@"MinPrice"];
        price = [[node stringValue] intValue];

        
        Offer *offer = [[Offer alloc] initWithCarrierName:name arrivalTime:time minPrice:price];
        [response.offers addObject:offer];
        [name release];
        [offer release];
    }
    
    
    
    [doc release];
    
    return response;
}

@end
