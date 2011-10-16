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
@synthesize fromArea = _fromArea;
@synthesize toArea = _toArea;
@synthesize comment = _comment;
@synthesize status = _status;
@synthesize carrier = _carrier;
@synthesize lat = _lat;
@synthesize lon = _lon;
@synthesize fromLat = _fromLat;
@synthesize toLat = _tolat;
@synthesize fromLon = _fromLon;
@synthesize toLon = _toLon;

@synthesize finishedAt = _finishedAt;
@synthesize schedule = _schedule;
@synthesize vType =_vType;
@synthesize orderId = _orderId;

- (id)initOrderWithDateTime:(NSString *)dateTime fromPlace:(NSString *)fromPlace toPlace:(NSString *)toPlace comment:(NSString *)comment
					 status:(NSString *)status carrier:(NSString *)carrier fromArea:(NSString *)fromArea toArea:(NSString *)toArea 
                        lat:(float)lat lon:(float)lon fromLat:(float)fromLat toLat:(float)toLat fromLon:(float)fromLon toLon:(float)toLon 
                 finishedAt:(NSString *)finishedAt schedule:(NSString *)schedule vType:(int)vType
{
    self = [super init];
    if (self != nil) {
        self.dateTime = dateTime;
        self.from = fromPlace;
        self.to = toPlace;
		self.comment = comment;
        self.carrier = carrier;
        self.lat = lat;
		self.lon = lon;
        self.fromLat = fromLat;
		self.toLat = toLat;
        self.fromLon = fromLon;
		self.toLon = toLon;
		self.status = status;
        self.fromArea = fromArea;
        self.toArea = toArea;
        
        self.finishedAt = finishedAt;
        self.schedule = schedule;
        self.vType = vType;
    }
    
    return self;
}

- (void)dealloc
{	
    [_finishedAt release];
    [_schedule release];
    [_fromArea release];
    [_toArea release];
	[_status release];
    [_carrier release];
    [_dateTime release];
	[_from release];
	[_to release];
	[_comment release];
    [super dealloc];
}


@end
