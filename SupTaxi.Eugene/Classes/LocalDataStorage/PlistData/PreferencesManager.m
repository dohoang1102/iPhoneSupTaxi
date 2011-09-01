//
//  PreferencesManager.m
//  SupTaxi
//
//  Created by Eugene Zavalko on 01.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "PreferencesManager.h"


@implementation PreferencesManager

@synthesize prefs;
@synthesize prefsFilePath;

-(NSString *)prefsFilePath{
	if (!prefsFilePath) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
		NSString *appApplicationSupportDirectoryPath = [paths objectAtIndex:0];
		prefsFilePath = [[appApplicationSupportDirectoryPath stringByAppendingPathComponent:@"Preferences.plist"] retain];
	}
	return prefsFilePath;
}

-(id)init{
	if ((self = [super init])) {
		self.prefs = [[Preferences alloc] initWithPath:[self prefsFilePath]];
	}
	return self;
}

- (void)dealloc
{
	[prefs release];
	[prefsFilePath release];
	
    [super dealloc];
}

#pragma mark Events


-(void)updateUserGuid:(NSString*)userGuid
{
	[[self prefs] setUserGuid:userGuid];
	if (self.prefs.userEmail == nil)[[self prefs] setUserEmail:@""];
	if (self.prefs.userPassword == nil)[[self prefs] setUserPassword:@""];
	if (self.prefs.userFirstName == nil) [[self prefs] setUserFirstName:@""];
	if (self.prefs.userSecondName == nil) [[self prefs] setUserSecondName:@""];
	[[self prefs] save];
}

-(void)updateUserCredentialsWithEmail:(NSString*)userEmail andPassword:(NSString*)userPassword
{
	if (self.prefs.userGuid == nil)	[[self prefs] setUserGuid:@""];
	[[self prefs] setUserEmail:userEmail];
	[[self prefs] setUserPassword:userPassword];
	if (self.prefs.userFirstName == nil) [[self prefs] setUserFirstName:@""];
	if (self.prefs.userSecondName == nil) [[self prefs] setUserSecondName:@""];
	[[self prefs] save];
}

-(void)updateUserDataWithName:(NSString*)userFirstName andSecondName:(NSString*)userSecondName
{
	if (self.prefs.userGuid == nil)	[[self prefs] setUserGuid:@""];
	if (self.prefs.userEmail == nil)[[self prefs] setUserEmail:@""];
	if (self.prefs.userPassword == nil)[[self prefs] setUserPassword:@""];
	[[self prefs] setUserFirstName:userFirstName];
	[[self prefs] setUserSecondName:userSecondName];
	[[self prefs] save];
}


@end
