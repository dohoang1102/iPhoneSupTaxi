//
//  Order.m
//  SupTaxi
//
//  Created by Eugene Zavalko on 05.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "Order.h"


@implementation Order

@synthesize dateTime = _dateTime;
@synthesize from = _from;
@synthesize to = _to;
@synthesize comment = _comment;
@synthesize status = _status;
@synthesize lat = _lat;
@synthesize lon = _lon;
@synthesize fromLat = _fromLat;
@synthesize toLat = _tolat;
@synthesize fromLon = _fromLon;
@synthesize toLon = _toLon;

- (id)initOrderWithDateTime:(NSString *)dateTime fromPlace:(NSString *)fromPlace toPlace:(NSString *)toPlace comment:(NSString *)comment
						status:(NSString*)status lat:(float)lat lon:(float)lon fromLat:(float)fromLat toLat:(float)toLat fromLon:(float)fromLon toLon:(float)toLon
{
    self = [super init];
    if (self != nil) {
        self.dateTime = dateTime;
        self.from = fromPlace;
        self.to = toPlace;
		self.comment = comment;
        self.lat = lat;
		self.lon = lon;
        self.fromLat = fromLat;
		self.toLat = toLat;
        self.fromLon = fromLon;
		self.toLon = toLon;
		self.status = status;
    }
    
    return self;
}

- (void)dealloc
{	
	[_status release];
    [_dateTime release];
	[_from release];
	[_to release];
	[_comment release];
    [super dealloc];
}


@end
