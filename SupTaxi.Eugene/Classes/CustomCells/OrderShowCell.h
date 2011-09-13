//
//  OrderShowCell.h
//  SupTaxi
//
//  Created by Eugene Zavalko on 01.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomSwitch.h"
#import "Offer.h"

@interface UIOfferImage : UIButton 

@property (nonatomic, retain) Offer *offer;

@end

@interface OrderShowCell : UITableViewCell

@property (nonatomic, retain) UILabel *priceLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UIOfferImage *carrierLogo;
@property (nonatomic, retain) UICustomSwitch *switcher;

@end
