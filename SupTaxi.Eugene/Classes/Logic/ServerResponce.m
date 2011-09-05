//
//  ServerResponce.m
//  tvjam
//
//  Created by Eugene Zavalko on 18.07.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "ServerResponce.h"
#import "ServerResponceXMLParser.h"

@interface ServerResponce(Private)

- (void) Clear;
- (BOOL) ProcessURLString:(NSString*)urlString;

@end



@implementation ServerResponce

+ (NSString *) orderRequestString
{
	return @"<Request Type=\"Order\" Guid=\"%@\" From=\"%@\" To=\"%@\" DateTime=\"%@\" VehicleType=\"%i\" IsRegular=\"%@\" Schedule=\"%@\" Lat=\"%f\" Lon=\"%f\" FromLat=\"%f\" FromLon=\"%f\" ToLat=\"%f\" ToLon=\"%f\" />";
}

- (NSArray *) GetDataItems
{
	return ((NSArray*)_dataItems);
}

- (BOOL) ProcessURLString:(NSString*)urlString withData:(NSString*)requestData
{
	_dataItems = [[NSMutableArray alloc] init];
	if (_dataItems) 
	{
		ServerResponceXMLParser * parser = [[ServerResponceXMLParser alloc] init];
		BOOL rslt = [parser ParseURLString:urlString withDataString:requestData toArray:_dataItems];
		if (rslt) 
		{
			//NSLog(@"Response: %@", _dataItems);
			//_navigateCount = [parser GetCount];
		}
		[parser release];
		return rslt;
	}
	return NO;
}

//Sending an order to server (not Regular)
- (BOOL) SendOrderRequest:(NSString*)guid from:(NSString*)from to:(NSString*)to date:(NSString*)orderDate vehicleType:(NSUInteger)vehicleType 
						   latitude: (float) latitude longitude: (float) longitude fromLat: (float) fromLat fromLon: (float) fromLon 
							  toLat: (float) toLat toLon: (float) toLon
{
	[self Clear];
	NSString * urlString = [ServerResponce GetRootURL];
	NSString *requestString = [NSString stringWithFormat:[ServerResponce orderRequestString],
							   guid, from, to, orderDate, vehicleType, @"false", @"", latitude, longitude, fromLat, fromLon, toLat, toLon];
    
	if (urlString) 
	{
		return [self ProcessURLString:urlString withData:requestString];
	}
	return false;
}

//Sending an order to server (Regular)
- (BOOL) SendOrderRequest:(NSString*)guid from:(NSString*)from to:(NSString*)to date:(NSString*)orderDate vehicleType:(NSUInteger)vehicleType 
						   isRegular: (BOOL) isRegular schedule: (NSString *) schedule latitude: (float) latitude longitude: (float) longitude 
							fromLat: (float) fromLat fromLon: (float) fromLon toLat: (float) toLat toLon: (float) toLon
{
	[self Clear];
	NSString * urlString = [ServerResponce GetRootURL];
	NSString *requestString = [NSString stringWithFormat:[ServerResponce orderRequestString],
							   guid, from, to, orderDate, vehicleType,((isRegular == NO) ? @"false" : @"true"), schedule, latitude, longitude, fromLat, fromLon, toLat, toLon];
    
	if (urlString) 
	{
		return [self ProcessURLString:urlString withData:requestString];
	}
	return false;
}

//Getting an offers from our order
- (BOOL) GetOffersForOrderRequest:(NSString*)orderGuid
{
	[self Clear];
	NSString * urlString = [ServerResponce GetRootURL];
	NSString *requestString = [NSString stringWithFormat:@"<Request Type=\"Order.Offers\" Guid=\"%@\" />", orderGuid];
    
	if (urlString) 
	{
		return [self ProcessURLString:urlString withData:requestString];
	}
	return false;
}

//Send offer accept request
- (BOOL) SendOrderAcceptWithOfferRequest:(NSString*)guid orderId:(NSString*)orderId carrierId:(NSString*)carrierId
{
	[self Clear];
	NSString * urlString = [ServerResponce GetRootURL];
	NSString *requestString = [NSString stringWithFormat:@"<Request Type=\"Order.Accept\" Guid=\"%@\" OrderId=\"%@\" CarrierId=\"%@\" />", 
							   guid, orderId, carrierId];
    
	if (urlString) 
	{
		return [self ProcessURLString:urlString withData:requestString];
	}
	return false;
}

//Sending registration request
- (BOOL) RegisterUserRequest:(NSString*)email password:(NSString*)password firstName:(NSString*)fName secondName:(NSString*)sName phone:(NSString*)phone
{
	[self Clear];
	NSString * urlString = [ServerResponce GetRootURL];
	NSString *requestString = [NSString stringWithFormat:@"<Request Type=\"Register\" Password=\"%@\" Email=\"%@\" FirstName=\"%@\" SecondName=\"%@\" Phone=\"%@\" City=\"\" ContractNumber=\"\" ContractCustomer=\"\" ContractCarrier=\"\" PreferredCarrier=\"\" />",
							   password, email, fName, sName, phone];
    
	if (urlString) 
	{
		return [self ProcessURLString:urlString withData:requestString];
	}
	return false;
}

//Sending login request
- (BOOL) LoginUserRequest:(NSString*)email password:(NSString*)password
{
	[self Clear];
	NSString * urlString = [ServerResponce GetRootURL];
	NSString *requestString = [NSString stringWithFormat:@"<Request Type=\"Login\" Email=\"%@\" Password=\"%@\" />",
							   email, password];
    
	if (urlString) 
	{
		return [self ProcessURLString:urlString withData:requestString];
	}
	return false;
}

//Get History
- (BOOL) GetOrdersHistoryRequest:(NSString*)userGuid pageNumber:(int)pageNumber numberOfRows:(int)numberOfRows
{
	[self Clear];
	NSString * urlString = [ServerResponce GetRootURL];
	NSString *requestString = [NSString stringWithFormat:@"<Request Type=\"History\" Guid=\"%@\" PageNumber=\"%i\" NumberOfRows=\"%i\" />",
							   userGuid, pageNumber, numberOfRows];
    
	if (urlString) 
	{
		return [self ProcessURLString:urlString withData:requestString];
	}
	return false;
}



- (void) Clear
{
	//SAFE_RELEASE(_dataItems);
	[_dataItems release];
}

- (id)init
{
	self = [super init];
	if (self)
	{
		_dataItems = nil;
	}
	return self;
}

- (void)dealloc
{
	[self Clear];
	
	[super dealloc];
}

+ (NSString*)GetRootURL
{
	return @"http://188.127.249.37/process/index";
}

@end
