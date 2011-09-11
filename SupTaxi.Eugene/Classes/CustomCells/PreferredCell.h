//
//  PreferredCell.h
//  SupTaxi
//
//  Created by Eugene Zavalko on 09.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomSwitch.h"

@interface PreferredCell : UITableViewCell 

@property (nonatomic, retain) UIImageView *carrierLogo;
@property (nonatomic, retain) UICustomSwitch *switcher;

@end
