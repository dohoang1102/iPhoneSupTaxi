//
//  MyClass.h
//  CustomTableView
//
//  Created by Igor Novik on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderShowCell : UITableViewCell

@property (nonatomic, retain) UILabel *priceLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UIImageView *carrierLogo;
@property (nonatomic, retain) UISwitch *switcher;

@end
