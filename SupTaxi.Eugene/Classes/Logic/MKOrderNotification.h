//
//  MKOrderNotification.h
//  SupTaxi
//
//  Created by Eugene Zavalko on 13.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKOrderNotification : NSObject

@property (nonatomic, assign) SEL selectorOnDone;
@property (nonatomic, assign) id delegate;

+ (MKOrderNotification*) sharedInstance;

- (void) scheduleNotificationOn:(NSDate*) fireDate
						   text:(NSString*) alertText
						 action:(NSString*) alertAction
						  sound:(NSString*) soundfileName
					launchImage:(NSString*) launchImage 
						andInfo:(NSDictionary*) userInfo;

- (void) handleReceivedNotification:(UILocalNotification*) thisNotification;

@end
