//
//  MyClass.h
//  CustomCells
//
//  Created by Eugene Zavalko on 01.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderShowCell : UITableViewCell

@property (nonatomic, retain) UILabel *priceLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UIImageView *carrierLogo;
@property (nonatomic, retain) UISwitch *switcher;

@end
