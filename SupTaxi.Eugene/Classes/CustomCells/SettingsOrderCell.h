//
//  MyClass.h
//  CustomCells
//
//  Created by Eugene Zavalko on 01.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomSwitch.h"

@interface SettingsOrderCell : UITableViewCell

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *valueLabel;
@property (nonatomic, retain) UICustomSwitch *switcher;

@end
