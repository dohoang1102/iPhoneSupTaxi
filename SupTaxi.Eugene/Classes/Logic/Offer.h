//
//  Offer.h
//  SupTaxi
//
//  Created by Eugene Zavalko on 29.08.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Offer : NSObject {
    
}

@property (nonatomic, copy) NSString *carrierName;
@property (nonatomic) int orderId;
@property (nonatomic) int carrierGuid;
@property (nonatomic, copy) UIImage *carrierLogo;
@property (nonatomic) int arrivalTime;
@property (nonatomic) int minPrice;
@property (nonatomic, copy) NSString *carrierDescription;

- (id)initWithCarrierName:(NSString *)carrierName arrivalTime:(int)arrivalTime minPrice:(int)minPrice 
				carrierId:(int) carrierId carrierLogoStr:(NSString*) carrierLogoStr carrierDescription:(NSString*)carrierDescription;

@end



