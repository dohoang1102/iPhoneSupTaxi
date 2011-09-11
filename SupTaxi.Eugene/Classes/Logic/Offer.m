//
//  Offer.m
//  SupTaxi
//
//  Created by Eugene Zavalko on 29.08.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "Offer.h"
#import "Constants.h"

@implementation Offer

@synthesize carrierName = carrierName_;
@synthesize arrivalTime = arrivalTime_;
@synthesize carrierGuid = carrierGuid_;
@synthesize minPrice = minPrice_;
@synthesize carrierLogo = carrierLogo_;
@synthesize orderId = orderId_;

- (id)initWithCarrierName:(NSString *)carrierName arrivalTime:(int)arrivalTime minPrice:(int)minPrice carrierId:(int) carrierId carrierLogoStr:(NSString*) carrierLogoStr
{
    self = [super init];
    if (self != nil) {
        self.carrierName = carrierName;
        self.arrivalTime = arrivalTime;
        self.minPrice = minPrice;
		self.carrierGuid = carrierId;
		self.carrierLogo = [Constants getImageFromString:carrierLogoStr];
    }
    
    return self;
}

- (void)dealloc
{
    [carrierName_ release];
	[carrierLogo_ release];
    [super dealloc];
}

@end
