//
//  WildCardGestureRecognizer.m
//  SupTaxi
//
//  Created by Alex Pavlysh on 9/21/11.
//  Copyright (c) 2011 DNK. All rights reserved.
//

#import "WildCardGestureRecognizer.h"
#import <UIKit/UIKit.h>

@implementation WildCardGestureRecognizer

@synthesize controller;
@synthesize mapView;
@synthesize touchTimer;
@synthesize justAddedPlacemark;

-(void)dealloc{
	[touchTimer release];
	
	[super dealloc];
}

-(id) init{
    if (self = [super init])
    {
        self.cancelsTouchesInView = NO;
    }
    return self;
}

-(void)invalidateTimer{
	[self.touchTimer invalidate];
	self.touchTimer = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	self.justAddedPlacemark = NO;
//	NSLog(@"Touches began:");
	if ([touches count] == 1) {
		UITouch *touch = [touches anyObject];
		touchedPoint = [touch locationInView:mapView];
		self.touchTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(addPlacemark) userInfo:nil repeats:NO];
	}
	
	if ([controller respondsToSelector:@selector(hideRouteView)]) {
		[controller performSelector:@selector(hideRouteView)];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
//	NSLog(@"Touches cancelled: %@", touches);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//	NSLog(@"Touches ended: %@", touches);
	[self invalidateTimer];
	
	if ([controller respondsToSelector:@selector(updateRouteView)]) {
		[controller performSelector:@selector(updateRouteView) withObject:nil afterDelay:0.5];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//	NSLog(@"Touches moved: %@", touches);
	[self invalidateTimer];
}

- (void)reset
{
}

- (void)ignoreTouch:(UITouch *)touch forEvent:(UIEvent *)event
{
}

- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer
{
    return NO;
}

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer
{
    return NO;
}

-(void)addPlacemark{
	self.justAddedPlacemark = YES;
	if (controller && [controller respondsToSelector:@selector(setPlaceAt:)]) {
		[controller performSelector:@selector(setPlaceAt:) withObject:[NSValue valueWithCGPoint:touchedPoint]];
	}
	[self invalidateTimer];
}

@end
