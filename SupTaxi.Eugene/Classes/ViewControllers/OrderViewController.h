//
//  OrderViewController.h
//  SupTaxi
//
//  Created by Eugene Zavalko on 29.08.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Response.h"
#import "PreferencesManager.h"
#import "MapViewController.h"
#import "MapViewRouteSearchBar.h"

#define kEconomicalCarType 1;
#define kBusinessCarType 2;
#define kCargoCarType 3;

@class CarriersViewController;

@interface OrderViewController : UIViewController<UIActionSheetDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {

@private
	ResponseOffers * _offerResponse;
	Response *			_orderResponse;
	PreferencesManager * prefManager;
	NSTimer * timer;
}

@property (nonatomic, retain) NSDictionary *carTypes;
@property (nonatomic, retain) MapViewController *mapViewController;
@property (nonatomic, retain) MapViewRouteSearchBar *mapViewRouteSearchBar;

@property (nonatomic, copy) NSString *dateTime;
@property (nonatomic, copy) NSString *carType;

@property (nonatomic, retain) Response * _orderResponse;
@property (nonatomic, retain) Response * _offerResponse;

@property (nonatomic, retain) NSTimer * timer;

@property (nonatomic, retain) CarriersViewController *cViewController;

- (IBAction)chooseDateTime:(id)sender;
- (IBAction)chooseCarType:(id)sender;

- (IBAction)orderTaxi:(id)sender;
- (IBAction)clearForm:(id)sender;

@end
