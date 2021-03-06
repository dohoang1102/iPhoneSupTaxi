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
	
	NSUInteger _navigatePage;
	NSUInteger _navigatePages;
	NSUInteger _navigateOnPage;
	NSUInteger _navigateCount;
}

- (NSArray *) GetDataItems;
- (NSUInteger) GetNavigatePage;
- (NSUInteger) GetNavigatePages;
- (NSUInteger) GetNavigateOnPage;
- (NSUInteger) GetNavigateCount;

- (BOOL) SendOrderRequest:(NSString*)guid from:(NSString*)from to:(NSString*)to date:(NSString*)orderDate vehicleType:(NSUInteger)vehicleType fromArea:(NSString*)fromArea toArea:(NSString*)toArea
				 latitude: (float) latitude longitude: (float) longitude fromLat: (float) fromLat fromLon: (float) fromLon 
					toLat: (float) toLat toLon: (float) toLon;
- (BOOL) SendOrderRequest:(NSString*)guid from:(NSString*)from to:(NSString*)to date:(NSString*)orderDate vehicleType:(NSUInteger)vehicleType fromArea:(NSString*)fromArea toArea:(NSString*)toArea
				isRegular: (BOOL) isRegular schedule: (NSString *) schedule latitude: (float) latitude longitude: (float) longitude 
				  fromLat: (float) fromLat fromLon: (float) fromLon toLat: (float) toLat toLon: (float) toLon;
- (BOOL) RegisterUserRequest:(NSString*)email password:(NSString*)password firstName:(NSString*)fName secondName:(NSString*)sName phone:(NSString*)phone;
- (BOOL) LoginUserRequest:(NSString*)email password:(NSString*)password;

- (BOOL) GetOffersForOrderRequest:(NSString*)orderGuid;
- (BOOL) SendOrderAcceptWithOfferRequest:(NSString*)guid orderId:(NSString*)orderId carrierId:(NSString*)carrierId;
- (BOOL) SendOrderRejectRequest:(NSString*)guid orderId:(int)orderId;

- (BOOL) GetOrdersHistoryRequest:(NSString*)userGuid pageNumber:(int)pageNumber numberOfRows:(int)numberOfRows;
- (BOOL) DelOrdersHistoryRequest:(NSString*)userGuid hId:(int)hId;

- (BOOL) GetAddressListRequest:(NSString*)userGuid;

- (BOOL) AddAddressRequest:(NSString*)userGuid name:(NSString*)name address:(NSString*)address area:(NSString*)area lat:(double)lat lon:(double)lon;
- (BOOL) DelAddressRequest:(NSString*)userGuid addressId:(NSInteger)addressId;
- (BOOL) UpdAddressRequest:(NSString*)userGuid addressId:(NSInteger)addressId name:(NSString*)name address:(NSString*)address area:(NSString*)area lat:(double)lat lon:(double)lon;

- (BOOL) GetPrefferedListRequest:(NSString*)userGuid;
- (BOOL) AddPreferredCarrierRequest:(NSString*)userGuid carrierId:(NSInteger)carrierId;
- (BOOL) DelPreferredCarrierRequest:(NSString*)userGuid carrierId:(NSInteger)carrierId;

- (BOOL) UpdateUserRequest:(NSString*)userGuid password:(NSString*)password email:(NSString*)email firstName:(NSString*)fName secondName:(NSString*)sName city:(NSString*)city cNumber:(NSString*)cNumber cCustomer:(NSString*)cCustomer cCarrier:(NSString*)cCarrier phone:(NSString*)phone;

- (BOOL) GetNearestAddressRequest:(NSString*)userGuid latitude: (float) latitude longitude: (float) longitude;

+ (NSString *)GetRootURL;


@end






