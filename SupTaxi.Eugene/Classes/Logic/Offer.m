//
//  Channel.m
//  tvjam
//
//  Created by Eugene Zavalko on 29.08.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "Offer.h"
//#import "ServerResponce.h"

@implementation Offer

@synthesize carrierName = carrierName_;
@synthesize arrivalTime = arrivalTime_;
@synthesize minPrice = minPrice_;

- (id)initWithCarrierName:(NSString *)carrierName arrivalTime:(int)arrivalTime minPrice:(int)minPrice
{
    self = [super init];
    if (self != nil) {
        self.carrierName = carrierName;
        self.arrivalTime = arrivalTime;
        self.minPrice = minPrice;
    }
    
    return self;
}

- (void)dealloc
{
    self.carrierName = nil;
    [super dealloc];
}

@end
