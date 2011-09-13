//
//  SupTaxiAppDelegate.h
//  SupTaxi
//
//  Created by Eugene Zavalko on 29.08.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PreferencesManager.h"
#import "Response.h"

@interface SupTaxiAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    
    UIWindow *window;
	UITabBarController *tabsController;
    PreferencesManager *prefManager;
	NSMutableDictionary * orderQueue; // key = orderId, value = leftTime;
	
@private
	ResponseOffers * _offerResponse;
	UIBackgroundTaskIdentifier bgTask;
	BOOL _backgroundWork;
	NSTimer * timer;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabsController;

@property (nonatomic, readonly) PreferencesManager *prefManager;
@property (nonatomic, retain) NSMutableDictionary * orderQueue;

@property (nonatomic, retain) Response * _offerResponse;

@property (nonatomic, retain) NSTimer * timer;

+ (SupTaxiAppDelegate *)sharedAppDelegate;

- (void) checkOrderOffers;

@end

