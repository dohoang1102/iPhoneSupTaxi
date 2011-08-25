//
//  SupTaxiAppDelegate.h
//  SupTaxi
//
//  Created by naceka on 15.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SupTaxiAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
