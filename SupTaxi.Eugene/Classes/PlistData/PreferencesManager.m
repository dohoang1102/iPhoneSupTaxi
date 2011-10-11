//
//  PreferencesManager.m
//  SupTaxi
//
//  Created by Eugene Zavalko on 01.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "PreferencesManager.h"

@interface PreferencesManager(Private)

//- (void) initFields;

@end


@implementation PreferencesManager

@synthesize prefs;
@synthesize prefsFilePath;

-(id)retain{
    NSLog(@"Retaining, new retain count: %i", [self retainCount] + 1);
    return [super retain];
}

-(oneway void)release{
    NSLog(@"Releasing, new retain count: %i", [self retainCount] - 1);
    [super release];
}

-(NSString *)prefsFilePath{
	if (!prefsFilePath) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
		NSString *appApplicationSupportDirectoryPath = [paths objectAtIndex:0];
        
        BOOL isDir;
        if (![[NSFileManager defaultManager] fileExistsAtPath:appApplicationSupportDirectoryPath isDirectory:&isDir] || !isDir){
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:appApplicationSupportDirectoryPath withIntermediateDirectories:YES attributes:nil error:&error];
            if (error) {
                NSLog(@"Unable to create path '%@': %@", appApplicationSupportDirectoryPath, error);
            }
        }
        
		prefsFilePath = [[appApplicationSupportDirectoryPath stringByAppendingPathComponent:@"Preferences.plist"] retain];
	}
	return prefsFilePath;
}

-(id)init{
	if ((self = [super init])) {
        Preferences * pref = [[Preferences alloc] initWithPath:[self prefsFilePath]];
		self.prefs = pref;
        [pref release];
		if (self.prefs.notFirstRun == NO) {
            [self.prefs setNotFirstRun:YES];
			[self initFields];
		}
	}
	return self;
}

- (void)dealloc
{
	[prefs release];
	[prefsFilePath release];
	
    [super dealloc];
}

#pragma mark initFieldsOnFirstLoad

-(void)initFields
{
	[[self prefs] setUserGuid:@""];
	[[self prefs] setUserEmail:@""];
	[[self prefs] setUserPassword:@""];
	[[self prefs] setUserFirstName:@""];
	[[self prefs] setUserSecondName:@""];
    [[self prefs] setUserCity:@""];
    [[self prefs] setUserPhone:@"+380663991175"];
    
	[[self prefs] setUserHasContract:NO];
	[[self prefs] setUserHasPrefered:YES];
	[[self prefs] setUserHasRegularOrder:NO];
	
	[[self prefs] setUserContractNumber:@""];
	[[self prefs] setUserContractCustomer:@""];
	[[self prefs] setUserContractCarrier:@""];
	
	[[self prefs] save];
}


#pragma mark Events


-(void)updateUserGuid:(NSString*)userGuid
{
	[[self prefs] setUserGuid:userGuid];
	[[self prefs] save];
}

-(void)updateUserCity:(NSString *)userCity
{
	[[self prefs] setUserCity:userCity];
	[[self prefs] save];
}

-(void)updateUserCredentialsWithEmail:(NSString*)userEmail andPassword:(NSString*)userPassword
{
	[[self prefs] setUserEmail:userEmail];
	[[self prefs] setUserPassword:userPassword];
	[[self prefs] save];
}

-(void)updateUserDataWithName:(NSString*)userFirstName andSecondName:(NSString*)userSecondName
{
	[[self prefs] setUserFirstName:userFirstName];
	[[self prefs] setUserSecondName:userSecondName];
	[[self prefs] save];
}

- (void) updateUserHasContract:(BOOL)hasContract
{
	[[self prefs] setUserHasContract:hasContract];
	[[self prefs] save];
}

- (void) updateUserHasPrefered:(BOOL)hasPrefered
{
	[[self prefs] setUserHasPrefered:hasPrefered];
	[[self prefs] save];
}

- (void) updateUserHasRegularOrder:(BOOL)hasRegularOrder
{
	[[self prefs] setUserHasRegularOrder:hasRegularOrder];
	[[self prefs] save];
}

- (void) updateUserContractWithNumber:(NSString*)contractNumber contractCustomer:(NSString*)customer andContractCarrier:(NSString*)carrier
{
    [[self prefs] setUserContractNumber:contractNumber];
	[[self prefs] setUserContractCustomer:customer];
	[[self prefs] setUserContractCarrier:carrier];
	[[self prefs] save];
}


@end
