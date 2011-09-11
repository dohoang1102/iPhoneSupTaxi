//
//  SupTaxiAppDelegate.m
//  SupTaxi
//
//  Created by Eugene Zavalko on 29.08.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "SupTaxiAppDelegate.h"
#import "TabBarBackgroundView.h"
#import "ServerResponce.h"

@interface SupTaxiAppDelegate(Private)

- (void) CheckOrderOffersThreadMethod:(id)obj;
- (void) ShowOrderOffers:(id)obj;
- (void) timerTargetMethod: (NSTimer *) theTimer;
@end

@implementation SupTaxiAppDelegate

#define CONST_REQTIME 5

@synthesize window;
@synthesize tabsController;
@synthesize prefManager;
@synthesize orderQueue;;
@synthesize _offerResponse;
@synthesize timer;

@synthesize orderDelegate;
@synthesize historyDelegate;
@synthesize addressDelegate;

+ (SupTaxiAppDelegate *)sharedAppDelegate
{
    return (SupTaxiAppDelegate *) [UIApplication sharedApplication].delegate;
}

- (void) CheckOrderOffersThreadMethod:(id)obj
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	ServerResponce * responce = [[ServerResponce alloc] init];
	if (responce) 
	{
		NSString * guid = (NSString*)obj;
		
		if ([responce GetOffersForOrderRequest:guid])
		{
			NSArray * resultData = [responce GetDataItems];
			if (resultData) {
				self._offerResponse = [resultData objectAtIndex:0]; 
			}
			
			[self performSelectorOnMainThread:@selector(ShowOrderResult:) 
								   withObject:nil 
								waitUntilDone:NO];
		}
		[responce release];
	}
	
	[pool release];
}

- (void) ShowOrderOffers:(id)obj
{
	
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	self.orderQueue = [[NSMutableDictionary alloc] init];
	
	prefManager = [[PreferencesManager alloc] init];
	
	CGRect frame = CGRectMake(0.0, 0.0, self.tabsController.tabBar.bounds.size.width, 48);
    TabBarBackgroundView *bacgroundView = [[TabBarBackgroundView alloc] initWithFrame:frame];
    [self.tabsController.tabBar insertSubview:bacgroundView atIndex:0];
    [bacgroundView release];
	
	self.window.rootViewController = self.tabsController;
    [self.window addSubview:self.tabsController.view];
    
    self.tabsController.selectedIndex = 3;//[[NSUserDefaults standardUserDefaults] integerForKey:@"currentTab"];
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	_backgroundWork = YES;
	
	NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
	[timeFormat setDateFormat:@"HH:mm:ss"];
	
	NSDate * date = [[NSDate alloc] init];
	
	NSString *theTime = [timeFormat stringFromDate:date];
	
	NSLog(@"\n"
		  "theTime: |%@| \n"
		  , theTime);
	
	NSLog(@"Application entered background state.");
    // bgTask is instance variable
    NSAssert(self->bgTask == UIBackgroundTaskInvalid, nil);
	
    bgTask = [application beginBackgroundTaskWithExpirationHandler: ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [application endBackgroundTask:self->bgTask];
            self->bgTask = UIBackgroundTaskInvalid;
        });
    }];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		int k = 0;
        while ([application backgroundTimeRemaining] > 1.0) {
			/*
			if (_backgroundWork) {
				NSLog(@"\n"
					  "theTime: |%@| \n"
					  , theTime);
			}else {
				break;
			}*/

            //NSString *friend = [self checkForIncomingChat];
            if (k == 2000000) {
                UILocalNotification *localNotif = [[UILocalNotification alloc] init];
                if (localNotif) {
                    localNotif.alertBody = [NSString stringWithFormat:
											NSLocalizedString(@"%i has a message for you.", nil), k];
                    localNotif.alertAction = NSLocalizedString(@"Read Message", nil);
                    //localNotif.soundName = @"alarmsound.caf";
                    //localNotif.applicationIconBadgeNumber = 1;
                    [application presentLocalNotificationNow:localNotif];
                    [localNotif release];
                    //friend = nil;
                    break;
                }
            }
			k++;
			
        }
        [application endBackgroundTask:self->bgTask];
        self->bgTask = UIBackgroundTaskInvalid;
    });
	
	NSString *theTime1 = [timeFormat stringFromDate:date];
	
	NSLog(@"\n"
		  "theTime: |%@| \n"
		  , theTime1);
	
	[timeFormat release];
	[date release];
	
    //[self saveContext];
}

- (void) checkOrderOffers
{
	timer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(timerTargetMethod:) userInfo:nil repeats: NO];
	NSLog(@"Timer started");
}


-(void) timerTargetMethod: (NSTimer *) theTimer {
	NSLog(@"Me is here at 1 minute delay");
	NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
	[timeFormat setDateFormat:@"HH:mm:ss"];
	
	NSDate * date = [[NSDate alloc] init];
	
	NSString *theTime = [timeFormat stringFromDate:date];
	
	NSLog(@"\n"
		  "theTime: |%@| \n"
		  , theTime);
	[timeFormat release];
	[date release];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
	_backgroundWork = NO;
	NSLog(@"Application exit background state.");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
   
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}



- (void)dealloc {
    
    [orderDelegate release];
    [historyDelegate release];
    [addressDelegate release];
    
	[prefManager release];
    [orderQueue release];
	
	[_offerResponse release];	
	[tabsController release];
	[timer release];
    [super dealloc];
}

#pragma mark -
#pragma mark Update remoteViews

- (void) updateOrderView
{
    
    NSLog(@"updateOrderView");
}
- (void) updateHistoryView
{
    if (self.historyDelegate) {
        
    }
    NSLog(@"updateHistoryView");
}
- (void) updateAddressView
{
	NSLog(@"updateAddressView");
}


@end

