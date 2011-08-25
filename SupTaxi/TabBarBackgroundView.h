//
//  TabBarBackgroundView.h
//  SupTaxi
//
//  Created by Igor Novik on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarBackgroundView : UIView

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, 
                        CGColorRef  endColor);

@end
