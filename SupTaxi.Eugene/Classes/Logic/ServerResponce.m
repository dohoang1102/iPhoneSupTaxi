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

+ (NSString *) xmlVersionString
{
	return @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
}

+ (NSString *) orderRequestString
{
	return @"<Request Type=\"Order\" Guid=\"%@\" From=\"%@\" To=\"%@\" DateTime=\"%@\" VehicleType=\"%i\" IsRegular=\"%@\" Schedule=\"%@\" Lat=\"%f\" Lon=\"%f\" FromLat=\"%f\" FromLon=\"%f\" ToLat=\"%f\" ToLon=\"%f\" FromDistrict=\"%@\" ToDistrict=\"%@\" />";
}

- (NSArray *) GetDataItems
{
	return ((NSArray*)_dataItems);
}

- (NSUInteger) GetNavigatePage
{
	return _navigatePage;
}
- (NSUInteger) GetNavigatePages
{
	return _navigatePages;
}
- (NSUInteger) GetNavigateOnPage
{
	return _navigateOnPage;
}
- (NSUInteger) GetNavigateCount
{
	return _navigateCount;
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
			_navigatePage = [parser GetPage];
			_navigatePages = [parser GetPages];
			_navigateOnPage = [parser GetOnPage];
			_navigateCount = [parser GetCount];
		}
		[parser release];
		return rslt;
	}
	return NO;
}

//Sending an order to server (not Regular)
- (BOOL) SendOrderRequest:(NSString*)guid from:(NSString*)from to:(NSString*)to date:(NSString*)orderDate vehicleType:(NSUInteger)vehicleType fromArea:(NSString*)fromArea toArea:(NSString*)toArea
						   latitude: (float) latitude longitude: (float) longitude fromLat: (float) fromLat fromLon: (float) fromLon 
							  toLat: (float) toLat toLon: (float) toLon
{
	[self Clear];
	NSString * urlString = [ServerResponce GetRootURL];
	NSString *requestString = [NSString stringWithFormat:@"%@\n%@", [ServerResponce xmlVersionString],[NSString stringWithFormat:[ServerResponce orderRequestString],
							   guid, from, to, orderDate, vehicleType, @"false", @"", latitude, longitude, fromLat, fromLon, toLat, toLon, fromArea, toArea]];
    
	if (urlString) 
	{
		return [self ProcessURLString:urlString withData:requestString];
	}
	return false;
}

//Sending an order to server (Regular)
- (BOOL) SendOrderRequest:(NSString*)guid from:(NSString*)from to:(NSString*)to date:(NSString*)orderDate vehicleType:(NSUInteger)vehicleType fromArea:(NSString*)fromArea toArea:(NSString*)toArea
						   isRegular: (BOOL) isRegular schedule: (NSString *) schedule latitude: (float) latitude longitude: (float) longitude 
							fromLat: (float) fromLat fromLon: (float) fromLon toLat: (float) toLat toLon: (float) toLon
{
	[self Clear];
	NSString * urlString = [ServerResponce GetRootURL];
	NSString *requestString = [NSString stringWithFormat:@"%@\n%@", [ServerResponce xmlVersionString],[NSString stringWithFormat:[ServerResponce orderRequestString],
							   guid, from, to, orderDate, vehicleType,((isRegular == NO) ? @"false" : @"true"), schedule, latitude, longitude, fromLat, fromLon, toLat, toLon, fromArea, toArea]];
    
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
	NSString *requestString = [NSString stringWithFormat:@"%@\n%@", [ServerResponce xmlVersionString],
							   [NSString stringWithFormat:@"<Request Type=\"Order.Offers\" Guid=\"%@\" />", orderGuid]];
    
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
	NSString *requestString = [NSString stringWithFormat:@"%@\n%@", [ServerResponce xmlVersionString],[NSString stringWithFormat:@"<Request Type=\"Order.Accept\" Guid=\"%@\" OrderId=\"%@\" CarrierId=\"%@\" />", 
							   guid, orderId, carrierId]];
    
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
	NSString *requestString = [NSString stringWithFormat:@"%@\n%@", [ServerResponce xmlVersionString],[NSString stringWithFormat:@"<Request Type=\"Register\" Password=\"%@\" Email=\"%@\" FirstName=\"%@\" SecondName=\"%@\" Phone=\"%@\" City=\"\" ContractNumber=\"\" ContractCustomer=\"\" ContractCarrier=\"\" />",
							   password, email, fName, sName, phone]];
    
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
	NSString *requestString = [NSString stringWithFormat:@"%@\n%@", [ServerResponce xmlVersionString],[NSString stringWithFormat:@"<Request Type=\"Login\" Email=\"%@\" Password=\"%@\" />",
							   email, password]];
    
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
	NSString *requestString = [NSString stringWithFormat:@"%@\n%@", [ServerResponce xmlVersionString],[NSString stringWithFormat:@"<Request Type=\"History\" Guid=\"%@\" PageNumber=\"%i\" NumberOfRows=\"%i\" />",
							   userGuid, pageNumber, numberOfRows]];
    
	if (urlString) 
	{
		return [self ProcessURLString:urlString withData:requestString];
	}
	return false;
}

// Get List of addresses
- (BOOL) GetAddressListRequest:(NSString*)userGuid{
	[self Clear];
	NSString * urlString = [ServerResponce GetRootURL];
	NSString *requestString = [NSString stringWithFormat:@"%@\n%@", [ServerResponce xmlVersionString],[NSString stringWithFormat:@"<Request Type=\"Addresses.List\" Guid=\"%@\" />", userGuid] ];
    
	if (urlString) 
	{
		return [self ProcessURLString:urlString withData:requestString];
	}
	return false;
}

//Add new address
- (BOOL) AddAddressRequest:(NSString*)userGuid name:(NSString*)name address:(NSString*)address area:(NSString*)area lat:(double)lat lon:(double)lon{
	[self Clear];
	NSString * urlString = [ServerResponce GetRootURL];
	NSString *requestString = [NSString stringWithFormat:@"%@\n%@", [ServerResponce xmlVersionString],[NSString stringWithFormat:@"<Request Type=\"Addresses.Add\" Guid=\"%@\" Name=\"%@\" Address=\"%@\" Lat=\"%f\" Lon=\"%f\" District=\"%@\"/>", 
							   userGuid, name, address, lat, lon, area]];
    
	if (urlString) 
	{
		return [self ProcessURLString:urlString withData:requestString];
	}
	return false;
}

//Remove address
- (BOOL) DelAddressRequest:(NSString*)userGuid addressId:(NSInteger)addressId{
	[self Clear];
	NSString * urlString = [ServerResponce GetRootURL];
	NSString *requestString = [NSString stringWithFormat:@"%@\n%@", [ServerResponce xmlVersionString],[NSString stringWithFormat:@"<Request Type=\"Addresses.Del\" Guid=\"%@\" AddressId=\"%i\" />", userGuid, addressId] ];
    
	if (urlString) 
	{
		return [self ProcessURLString:urlString withData:requestString];
	}
	return false;
}

//Add new address
- (BOOL) UpdAddressRequest:(NSString*)userGuid addressId:(NSInteger)addressId name:(NSString*)name address:(NSString*)address area:(NSString*)area lat:(double)lat lon:(double)lon{
	[self Clear];
	NSString * urlString = [ServerResponce GetRootURL];
	NSString *requestString = [NSString stringWithFormat:@"%@\n%@", [ServerResponce xmlVersionString],[NSString stringWithFormat:@"<Request Type=\"Addresses.Upd\" Guid=\"%@\" AddressId=\"%i\" Name=\"%@\" Address=\"%@\" Lat=\"%f\" Lon=\"%f\" District=\"%@\"/>", 
							   userGuid, addressId, name, address, lat, lon, area]];
    
	if (urlString) 
	{
		return [self ProcessURLString:urlString withData:requestString];
	}
	return false;
}

// Get List of carriers with preferred
- (BOOL) GetPrefferedListRequest:(NSString*)userGuid{
	[self Clear];
	NSString * urlString = [ServerResponce GetRootURL];
	NSString *requestString = [NSString stringWithFormat:@"%@\n%@", [ServerResponce xmlVersionString],[NSString stringWithFormat:@"<Request Type=\"Carriers.List\" Guid=\"%@\" IncludePreffered=\"true\" />", userGuid] ];
    
	if (urlString) 
	{
		return [self ProcessURLString:urlString withData:requestString];
	}
	return false;
}

//Add to preferred
- (BOOL) AddPreferredCarrierRequest:(NSString*)userGuid carrierId:(NSInteger)carrierId{
	[self Clear];
	NSString * urlString = [ServerResponce GetRootURL];
	NSString *requestString = [NSString stringWithFormat:@"%@\n%@", [ServerResponce xmlVersionString],[NSString stringWithFormat:@"<Request Type=\"PrefferedCarriers.Add\" Guid=\"%@\" CarrierId=\"%i\" />", userGuid, carrierId] ];
    
	if (urlString) 
	{
		return [self ProcessURLString:urlString withData:requestString];
	}
	return false;
}

//Delete from preferred
- (BOOL) DelPreferredCarrierRequest:(NSString*)userGuid carrierId:(NSInteger)carrierId{
	[self Clear];
	NSString * urlString = [ServerResponce GetRootURL];
	NSString *requestString = [NSString stringWithFormat:@"%@\n%@", [ServerResponce xmlVersionString],[NSString stringWithFormat:@"<Request Type=\"PrefferedCarriers.Del\" Guid=\"%@\" CarrierId=\"%i\" />", userGuid, carrierId] ];
    
	if (urlString) 
	{
		return [self ProcessURLString:urlString withData:requestString];
	}
	return false;
}

- (BOOL) UpdateUserRequest:(NSString*)userGuid password:(NSString*)password email:(NSString*)email firstName:(NSString*)fName secondName:(NSString*)sName city:(NSString*)city cNumber:(NSString*)cNumber cCustomer:(NSString*)cCustomer cCarrier:(NSString*)cCarrier phone:(NSString*)phone
{
    [self Clear];
	NSString * urlString = [ServerResponce GetRootURL];
	NSString *requestString = [NSString stringWithFormat:@"%@\n%@", [ServerResponce xmlVersionString],
                               [NSString stringWithFormat:@"<Request Type=\"User.Update\" Guid=\"%@\" Password=\"%@\" Email=\"%@\" FirstName=\"%@\" SecondName=\"%@\" City=\"%@\" ContractNumber=\"%@\" ContractCustomer=\"%@\" ContractCarrier=\"%@\" Phone=\"%@\" />", userGuid, password, email, fName, sName, city, cNumber, cCustomer, cCarrier, phone] ];
    
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
