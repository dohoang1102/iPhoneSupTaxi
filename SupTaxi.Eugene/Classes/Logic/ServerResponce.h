//
//  ServerResponce.h
//  tvjam
//
//  Created by Eugene Zavalko on 18.07.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ServerResponce : NSObject 
{
@private
	NSMutableArray * _dataItems;
	
	
}

- (NSArray *) GetDataItems;

- (BOOL) SendOrderRequest:(NSString*)guid from:(NSString*)from to:(NSString*)to date:(NSString*)orderDate vehicleType:(NSUInteger)vehicleType 
				 latitude: (float) latitude longitude: (float) longitude fromLat: (float) fromLat fromLon: (float) fromLon 
					toLat: (float) toLat toLon: (float) toLon;
- (BOOL) SendOrderRequest:(NSString*)guid from:(NSString*)from to:(NSString*)to date:(NSString*)orderDate vehicleType:(NSUInteger)vehicleType 
				isRegular: (BOOL) isRegular schedule: (NSString *) schedule latitude: (float) latitude longitude: (float) longitude 
				  fromLat: (float) fromLat fromLon: (float) fromLon toLat: (float) toLat toLon: (float) toLon;
- (BOOL) RegisterUserRequest:(NSString*)email password:(NSString*)password firstName:(NSString*)fName secondName:(NSString*)sName phone:(NSString*)phone;
- (BOOL) LoginUserRequest:(NSString*)email password:(NSString*)password;

- (BOOL) GetOffersForOrderRequest:(NSString*)orderGuid;
- (BOOL) SendOrderAcceptWithOfferRequest:(NSString*)guid orderId:(NSString*)orderId carrierId:(NSString*)carrierId;

- (BOOL) GetOrdersHistoryRequest:(NSString*)userGuid pageNumber:(int)pageNumber numberOfRows:(int)numberOfRows;

- (BOOL) GetAddressListRequest:(NSString*)userGuid;
- (BOOL) AddAddressRequest:(NSString*)userGuid name:(NSString*)name address:(NSString*)address lat:(double)lat lon:(double)lon;
- (BOOL) DelAddressRequest:(NSString*)userGuid addressId:(NSInteger)addressId;

+ (NSString *)GetRootURL;


@end






