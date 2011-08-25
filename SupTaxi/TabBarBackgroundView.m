//
//  TabBarBackgroundView.m
//  SupTaxi
//
//  Created by Igor Novik on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TabBarBackgroundView.h"

@implementation TabBarBackgroundView

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, 
                        CGColorRef  endColor) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = [NSArray arrayWithObjects:(id)startColor, (id)endColor, nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, 
                                                        (CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef whiteColor = [UIColor colorWithRed:16.0/255.0 green:79.0/255.0 blue:13.0/255.0 alpha:1].CGColor; 
    CGColorRef lightGrayColor = [UIColor colorWithRed:2.0/255.0 green:12.0/255.0 
                                                 blue:2.0/255.0 alpha:1.0].CGColor;
    
    CGRect paperRect = self.bounds;
    
    drawLinearGradient(context, paperRect, whiteColor, lightGrayColor);
}

@end
