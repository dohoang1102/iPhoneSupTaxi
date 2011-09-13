//
//  MKOrderNotification.m
//  SupTaxi
//
//  Created by Eugene Zavalko on 13.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "MKOrderNotification.h"

static MKOrderNotification *_instance;

@implementation MKOrderNotification

@synthesize selectorOnDone;
@synthesize delegate;

+ (MKOrderNotification*)sharedInstance
{
	@synchronized(self) {
		
        if (_instance == nil) {
			
			// iOS 4 compatibility check
			Class notificationClass = NSClassFromString(@"UILocalNotification");
			
			if(notificationClass == nil)
			{
				_instance = nil;
			}
			else 
			{				
				_instance = [[super allocWithZone:NULL] init];				
			}
        }
    }
    return _instance;
}

+ (id)allocWithZone:(NSZone *)zone
{	
    return [[self sharedInstance] retain];
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{	
    return self;	
}

- (unsigned)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (id)autorelease
{
    return self;	
}

- (void) scheduleNotificationOn:(NSDate*) fireDate
                           text:(NSString*) alertText
                         action:(NSString*) alertAction
                          sound:(NSString*) soundfileName
                    launchImage:(NSString*) launchImage 
                        andInfo:(NSDictionary*) userInfo


{
	UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];	

    localNotification.alertBody = alertText;
    localNotification.alertAction = alertAction;	
	
	if(soundfileName == nil)
	{
		localNotification.soundName = UILocalNotificationDefaultSoundName;
	}
	else 
	{
		localNotification.soundName = soundfileName;
	}
    
	localNotification.alertLaunchImage = launchImage;
	
	localNotification.userInfo = userInfo;
	
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    [localNotification release];
}

- (void) handleReceivedNotification:(UILocalNotification*) thisNotification
{
    if (self.delegate){
        [self.delegate performSelector:selectorOnDone];
    }
	NSLog(@"Received: %@",[thisNotification description]);
}

@end
