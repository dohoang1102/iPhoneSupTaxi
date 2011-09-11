//
//  Preferences.h
//  SupTaxi
//
//  Created by Eugene Zavalko on 01.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PListData.h"
#import <UIKit/UIKit.h>

@interface Preferences : PListData{
	BOOL notFirstRun;
	
	NSString *userGuid;
	NSString *userEmail;
	NSString *userPassword;
	NSString *userFirstName;
	NSString *userSecondName;
	NSString *userCity;
    
	BOOL userHasContract;
	BOOL userHasPrefered;
	BOOL userHasRegularOrder;
	
	NSString *userContractNumber;
	NSString *userContractCustomer;
	NSString *userContractCarrier;
}

@property(nonatomic, assign) BOOL notFirstRun;

@property(nonatomic, copy) NSString *userGuid;
@property(nonatomic, copy) NSString *userEmail;
@property(nonatomic, copy) NSString *userPassword;
@property(nonatomic, copy) NSString *userFirstName;
@property(nonatomic, copy) NSString *userSecondName;
@property(nonatomic, copy) NSString *userCity;

@property(nonatomic) BOOL userHasContract;
@property(nonatomic) BOOL userHasPrefered;
@property(nonatomic) BOOL userHasRegularOrder;

@property(nonatomic, copy) NSString *userContractNumber;
@property(nonatomic, copy) NSString *userContractCustomer;
@property(nonatomic, copy) NSString *userContractCarrier;

@end
