//
//  Channel.h
//  tvjam
//
//  Created by Eugene Zavalko on 29.08.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ResponceObject.h"

@interface Offer : NSObject {
    
}

@property (nonatomic, copy) NSString *carrierName;
@property (nonatomic) int arrivalTime;
@property (nonatomic) int minPrice;

- (id)initWithCarrierName:(NSString *)carrierName arrivalTime:(int)arrivalTime minPrice:(int)minPrice;

@end



