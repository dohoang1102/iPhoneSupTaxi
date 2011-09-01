//
//  Preferences.h
//  ReverseLobotomy
//
//  Created by Eugene Zavalko on 01.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PListData.h"
#import <UIKit/UIKit.h>

@interface Preferences : PListData{

	NSString *userGuid;
	NSString *userEmail;
	NSString *userPassword;
	NSString *userFirstName;
	NSString *userSecondName;
}

@property(nonatomic, copy) NSString *userGuid;
@property(nonatomic, copy) NSString *userEmail;
@property(nonatomic, copy) NSString *userPassword;
@property(nonatomic, copy) NSString *userFirstName;
@property(nonatomic, copy) NSString *userSecondName;

@end
