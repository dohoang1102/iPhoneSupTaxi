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
- (BOOL) SendOrderRequestNotRegular:(NSString*)guid from:(NSString*)from to:(NSString*)to date:(NSString*)orderDate vehicleType:(NSUInteger)vehicleType
{
	[self Clear];
	NSString * urlString = [ServerResponce GetRootURL];
	NSString *requestString = [NSString stringWithFormat:@"<Request Type=\"Order\" Guid=\"%@\" From=\"%@\" To=\"%@\" DateTime=\"%@\" VehicleType=\"%i\" IsRegular=\"false\" Schedule=\"\" />", guid, from, to, orderDate, vehicleType];
    
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
