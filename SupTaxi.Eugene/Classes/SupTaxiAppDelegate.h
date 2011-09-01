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
	NSString * currentOrderGuid;
	
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
	ResponseOffers * _offerResponse;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabsController;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, readonly) PreferencesManager *prefManager;
@property (nonatomic, copy) NSString * currentOrderGuid;

@property (nonatomic, retain) Response * _offerResponse;

+ (SupTaxiAppDelegate *)sharedAppDelegate;

- (void) checkOrderOffers;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

@end

