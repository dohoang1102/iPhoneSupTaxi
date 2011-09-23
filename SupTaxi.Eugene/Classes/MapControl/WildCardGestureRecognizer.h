//
//  WildCardGestureRecognizer.h
//  SupTaxi
//
//  Created by Alex Pavlysh on 9/21/11.
//  Copyright (c) 2011 DNK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//typedef void (^TouchesEventBlock)(NSSet * touches, UIEvent * event);

@interface WildCardGestureRecognizer : UIGestureRecognizer {
	//TouchesEventBlock touchesBeganCallback;
	CGPoint touchedPoint;
	
	id controller;
	UIView *mapView;
}
@property(nonatomic, assign) id controller;
@property(nonatomic, assign) UIView *mapView;
@property(nonatomic, retain) NSTimer *touchTimer;
@property (nonatomic, assign) BOOL justAddedPlacemark;

//@property(copy) TouchesEventBlock touchesBeganCallback;

@end
