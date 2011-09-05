//
//  UICustomSwitch.h
//  SupTaxi
//
//  Created by Eugene Zavalko on 03.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UICustomSwitch : UISlider {
	BOOL on;
	UIColor *tintColor;
	UIView *clippingView;
	UILabel *rightLabel;
	UILabel *leftLabel;
	
	// private member
	BOOL m_touchedSelf;
}

@property(nonatomic,getter=isOn) BOOL on;
@property (nonatomic,retain) UIColor *tintColor;
@property (nonatomic,retain) UIView *clippingView;
@property (nonatomic,retain) UILabel *rightLabel;
@property (nonatomic,retain) UILabel *leftLabel;

+ (UICustomSwitch *) switchWithLeftText: (NSString *) tag1 andRight: (NSString *) tag2;

- (void)setTintColor:(UIColor *)color;
- (void)setText: (NSString *) tag1 andRight: (NSString *) tag2;
- (void)setOn:(BOOL)on animated:(BOOL)animated;
- (void)scaleSwitch:(CGSize)newSize;

@end
