//
//  Response.m
//  SupTaxi
//
//  Created by Eugene Zavalko on 30.08.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "Response.h"


@implementation Response

@synthesize _responseType;
@synthesize _result;
@synthesize _guid;

- (id)initWithResponseType:(NSString *)responseType andResult:(BOOL)result{
    self = [super init];
    if (self != nil) {
        self._responseType = responseType;
         [self set_result:result];
    }
    
    return self;
}

- (id)initWithResponseType:(NSString *)responseType result:(BOOL)result andGuid:(NSString *)guid{
    self = [super init];
    if (self != nil) {
        self._responseType = responseType;
        [self set_result:result];
		self._guid = guid;
    }
    
    return self;
}

- (void)dealloc
{
    self._responseType = nil;
	self._guid = nil;
    [super dealloc];
}

@end

@implementation ResponseLogin

@synthesize _firstName;
@synthesize _secondName;
@synthesize _wrongPassword;

- (void)dealloc
{
    self._firstName = nil;
	self._secondName = nil;
    [super dealloc];
}

@end

@implementation ResponseOffers

@synthesize _status;
@synthesize _offers;
@synthesize _from;
@synthesize _to;


-(id)init{
	if ((self = [super init])) {
		_offers = [NSMutableArray array];
	}
	return self;
}

- (void)addAnOffer:(Offer *)offer
{
	[self._offers addObject:offer];
}

- (void)dealloc
{
	self._from = nil;
	self._to = nil;
	[_offers release];
    [super dealloc];
}

@end