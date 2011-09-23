//
//  MapViewControllerTouch.h
//  SupTaxi
//
//  Created by Alex Pavlysh on 9/21/11.
//  Copyright (c) 2011 DNK. All rights reserved.
//

#import "MapViewController.h"
#import "WildCardGestureRecognizer.h"
#import "AddressViewControllerDelegate.h"
#import "GoogleServiceManager.h"
#import "GoogleServiceManagerDelegate.h"

@interface MapViewControllerTouch : MapViewController <GoogleServiceManagerDelegate>

@property (nonatomic, retain) UIBarButtonItem *okButton;

@property (nonatomic, retain) WildCardGestureRecognizer *tapInterceptor;
@property (nonatomic, retain) NSMutableArray *pointsArray;
@property (nonatomic, retain) GoogleServiceManager *googleServiceManager;

@property (nonatomic, assign) id<AddressViewControllerDelegate> selectionDelegate;

-(void)setPlaceAt:(NSValue *)pointValue;
-(void)moveToMoscow;

@end
