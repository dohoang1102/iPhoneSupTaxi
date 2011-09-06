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
		_offers = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)addAnOffer:(Offer *)offer
{
	if (self._offers == nil) {	_offers = [[NSMutableArray alloc] init]; }
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

@implementation ResponseHistory

@synthesize _orders;

-(id)init{
	if ((self = [super init])) {
		_orders = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)addAnOrder:(Order *)order
{
	if (self._orders == nil) {	_orders = [[NSMutableArray alloc] init]; }
	[self._orders addObject:order];
}

- (void)dealloc
{
	[_orders release];
    [super dealloc];
}

@end

@implementation ResponseAddress

@synthesize _addressId;
@synthesize _addressList;

-(id)init{
	if ((self = [super init])) {
		_addressList = [[NSMutableArray alloc] init];
	}
	return self;
}

- (id)initWithResponseType:(NSString *)responseType result:(BOOL)result andAddressId:(NSInteger)addressId{
    if ((self = [super initWithResponseType:responseType andResult:result])) {
		_addressList = [[NSMutableArray alloc] init];
		[self set_addressId:addressId];
    }
    
    return self;
}

- (void)addAnAddress:(Address *)address
{
	if (self._addressList == nil) {	_addressList = [[NSMutableArray alloc] init]; }
	[self._addressList addObject:address];
}

- (void)dealloc
{
	[_addressList release];
    [super dealloc];
}

@end
