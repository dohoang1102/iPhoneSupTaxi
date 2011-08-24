//
//  OrderResponse.h
//  SupTaxi
//
//  Created by naceka on 19.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Offer : NSObject {
    
}

@property (nonatomic, copy) NSString *carrierName;
@property (nonatomic) int arrivalTime;
@property (nonatomic) int minPrice;

- (id)initWithCarrierName:(NSString *)carrierName arrivalTime:(int)arrivalTime minPrice:(int)minPrice;

@end
