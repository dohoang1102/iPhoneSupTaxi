//
//  PreferencesManager.h
//  SupTaxi
//
//  Created by Eugene Zavalko on 01.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Preferences.h"

@interface PreferencesManager : NSObject {
	Preferences *prefs;
	NSString *prefsFilePath;
}

@property (nonatomic, retain) Preferences *prefs;
@property (nonatomic, retain) NSString *prefsFilePath;

- (void) updateUserGuid:(NSString*)userGuid;
- (void) updateUserCredentialsWithEmail:(NSString*)userEmail andPassword:(NSString*)userPassword;
- (void) updateUserDataWithName:(NSString*)userFirstName andSecondName:(NSString*)userSecondName;

- (void) updateUserHasContract:(BOOL)hasContract;
- (void) updateUserHasPrefered:(BOOL)hasPrefered;
- (void) updateUserHasRegularOrder:(BOOL)hasRegularOrder;

- (void) updateUserContractWithNumber:(NSString*)contractNumber contractCustomer:(NSString*)customer andContractCarrier:(NSString*)currier;

@end
