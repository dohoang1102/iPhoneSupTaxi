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
@synthesize _city;
@synthesize _contractNumber;
@synthesize _contractCustomer;
@synthesize _contractCarrier;

- (id)initWithResponseType:(NSString *)responseType result:(BOOL)result guid:(NSString *)guid fName:(NSString *)fName sName:(NSString *)sName wrongPass:(BOOL) wrongPass city:(NSString*)city cNumber:(NSString*)cNumber cCustomer:(NSString*)cCustomer cCarrier:(NSString*)cCarrier{
    self = [super initWithResponseType:responseType result:result andGuid:guid];
    if (self != nil) {
		[self set_firstName:fName];
		[self set_secondName:sName];
		[self set_wrongPassword:wrongPass];
        [self set_city:city];
        [self set_contractNumber:cNumber];
        [self set_contractCustomer:cCustomer];
        [self set_contractCarrier:cCarrier];
	}
    
    return self;
}
- (void)dealloc
{
    self._firstName = nil;
	self._secondName = nil;
    self._city = nil;
    self._contractNumber = nil;
    self._contractCustomer = nil;
    self._contractCarrier = nil;
    [super dealloc];
}

@end

@implementation ResponseOffers

@synthesize _status;
@synthesize _offers;
@synthesize _from;
@synthesize _to;

- (id)initWithResponseType:(NSString *)responseType result:(BOOL)result guid:(NSString *)guid from:(NSString *)from to:(NSString *)to andStatus:(BOOL) status{
	self = [super initWithResponseType:responseType result:result andGuid:guid];
    if (self != nil) {
		_offers = [[NSMutableArray alloc] init];
		[self set_status:status];
		[self set_from:from];
		[self set_to:to];
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
@synthesize _page;
@synthesize _pages;
@synthesize _onPage;
@synthesize _count;

-(id)init{
	if ((self = [super init])) {
		_orders = [[NSMutableArray alloc] init];
		_page = 0;
		_pages = 0;
		_onPage = 0;
		_count = 0;
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

@implementation ResponseNearestAddress

@synthesize address;

- (id)initWithResponseType:(NSString *)responseType andResult:(BOOL)result{
    if ((self = [super initWithResponseType:responseType andResult:result])) {
    }
    
    return self;
}
- (void)dealloc
{
	[address release];
    [super dealloc];
}

@end


@implementation ResponsePreferred

@synthesize _carriers;

-(id)init{
	if ((self = [super init])) {
		_carriers = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)addCarrier:(Carrier *)carrier
{
	if (self._carriers == nil) {	_carriers = [[NSMutableArray alloc] init]; }
	[self._carriers addObject:carrier];
}

- (void)dealloc
{
	[_carriers release];
    [super dealloc];
}

@end
