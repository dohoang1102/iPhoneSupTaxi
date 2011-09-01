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

- (BOOL) SendOrderRequestNotRegular:(NSString*)guid from:(NSString*)from to:(NSString*)to date:(NSString*)orderDate vehicleType:(NSUInteger)vehicleType;
- (BOOL) RegisterUserRequest:(NSString*)email password:(NSString*)password firstName:(NSString*)fName secondName:(NSString*)sName phone:(NSString*)phone;
- (BOOL) LoginUserRequest:(NSString*)email password:(NSString*)password;


- (BOOL) GetOffersForOrderRequest:(NSString*)orderGuid;

+ (NSString *)GetRootURL;


@end






