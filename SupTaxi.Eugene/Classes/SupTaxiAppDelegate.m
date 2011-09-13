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
#import "AppProgress.h"
#import "MKOrderNotification.h"

@interface SupTaxiAppDelegate(Private)

- (void) showAlertMessage:(NSString *)alertMessage;

- (void) CheckInetAndServerThreadMethod:(id)sender;
- (void) ShowConnectionAlert:(id)obj;
@end

@implementation SupTaxiAppDelegate

#define CONST_REQTIME 5

@synthesize window;
@synthesize tabsController;
@synthesize prefManager;

+ (SupTaxiAppDelegate *)sharedAppDelegate
{
    return (SupTaxiAppDelegate *) [UIApplication sharedApplication].delegate;
}

- (void) CheckInetAndServerThreadMethod:(id)sender
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	AppProgress * progress = [AppProgress GetDefaultAppProgress];
	
	[progress StartProcessing:@"Проверка интернет соединения"];
	
	ServerResponce * responce = [[ServerResponce alloc] init];
	if (![responce GetAddressListRequest:@"0"]) 
	{
			[self performSelectorOnMainThread:@selector(ShowConnectionAlert:) 
								   withObject:nil 
								waitUntilDone:NO];
	}
	[progress StopProcessing:@"Готово" andHideTime:0.5];
	
	[pool release];
}

- (void) ShowConnectionAlert:(id)obj
{
	[self showAlertMessage:@"Проверьте интернет соединение!"];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	//self.orderQueue = [[NSMutableDictionary alloc] init];
	
	prefManager = [[PreferencesManager alloc] init];
	
	CGRect frame = CGRectMake(0.0, 0.0, self.tabsController.tabBar.bounds.size.width, 48);
    TabBarBackgroundView *bacgroundView = [[TabBarBackgroundView alloc] initWithFrame:frame];
    [self.tabsController.tabBar insertSubview:bacgroundView atIndex:0];
    [bacgroundView release];
	
	self.window.rootViewController = self.tabsController;
    [self.window addSubview:self.tabsController.view];
    
    self.tabsController.selectedIndex = 3;//[[NSUserDefaults standardUserDefaults] integerForKey:@"currentTab"];
    [self.window makeKeyAndVisible];
    
    AppProgress * progress = [AppProgress GetDefaultAppProgress];
	[progress SetApplicationWindow:self.window];
	
	[NSThread detachNewThreadSelector:@selector(CheckInetAndServerThreadMethod:) 
							 toTarget:self 
						   withObject:nil];  
     
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
	
    if (localNotification) 
	{
		[[MKOrderNotification sharedInstance] handleReceivedNotification:localNotification];
    }
    
    return YES;
}

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)localNotification {
    
	[[MKOrderNotification sharedInstance] handleReceivedNotification:localNotification];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}



- (void)dealloc {
        
	[prefManager release];

	[_offerResponse release];	
	[tabsController release];

    [super dealloc];
}

- (void) showAlertMessage:(NSString *)alertMessage
{
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" 
													 message:alertMessage 
													delegate:nil 
										   cancelButtonTitle:@"OK" 
										   otherButtonTitles:nil];
	[alert show];
	[alert release];
}

@end

