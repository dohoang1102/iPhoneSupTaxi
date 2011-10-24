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
	NSString * currentOrderId;
@private
	ResponseOffers * _offerResponse;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabsController;

@property (nonatomic, readonly) PreferencesManager *prefManager;
@property (nonatomic, retain) NSString * currentOrderId;

+ (SupTaxiAppDelegate *)sharedAppDelegate;

//- (void) checkOrderOffers;

@end

