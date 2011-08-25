//
//  BarButtonItemGreenColor.h
//  SupTaxi
//
//  Created by Igor Novik on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (BarButtonItemGreenColor)

+(UIBarButtonItem*)barButtonItemWithTint:(UIColor*)color andTitle:(NSString*)itemTitle andTarget:(id)theTarget andSelector:(SEL)selector;

@end
