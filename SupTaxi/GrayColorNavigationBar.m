//
//  GrayColorNavigationBar.m
//  SupTaxi
//
//  Created by Igor Novik on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
/// asliudgals

#import "GrayColorNavigationBar.h"

@implementation UINavigationBar (GrayColorNavigationBar)

- (void) awakeFromNib
{
    self.tintColor = [UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1];
}

@end
