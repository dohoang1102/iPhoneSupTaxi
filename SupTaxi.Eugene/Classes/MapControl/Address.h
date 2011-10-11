//
//  Address.h
//  SupTaxi
//
//  Created by Eugene Zavalko on 06.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoogleResultPlacemark.h"

@interface Address : NSObject {

}

@property (nonatomic, assign) NSInteger  addressId;
@property (nonatomic, retain) NSString * addressName;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, assign) NSInteger addressType; //0 - general 1- station 2 - aero
@property (nonatomic, retain) NSString * addressArea;

-(id)initWithId:(NSInteger) addrId name:(NSString*)name address:(NSString*)addressString addressArea:(NSString*)area type:(NSInteger)type lon:(double)lon lat:(double)lat;
-(void)initiateWithId:(NSInteger) addrId name:(NSString*)name address:(NSString*)addressString addressArea:(NSString*)area type:(NSInteger)type lon:(double)lon lat:(double)lat;
-(void)initWithGoogleResultPlacemark:(GoogleResultPlacemark *)placeMark;
-(GoogleResultPlacemark *)googleResultPlacemark;

@end
