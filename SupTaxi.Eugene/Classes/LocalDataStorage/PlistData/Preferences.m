//
//  Preferences.m
//  ReverseLobotomy
//
//  Created by Eugene Zavalko on 01.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "Preferences.h"

@implementation Preferences

#pragma mark Properties

@synthesize userGuid;
@synthesize userEmail;
@synthesize userPassword;
@synthesize userFirstName;
@synthesize userSecondName;

+(NSString*)userGuidAttrName{
	return @"userGuid";
}
+(NSString*)userEmailAttrName{
	return @"userEmail";
}
+(NSString*)userPasswordAttrName{
	return @"userPassword";
}
+(NSString*)userFirstNameAttrName{
	return @"userFirstName";
}
+(NSString*)userSecondNameAttrName{
	return @"userSecondName";
}

#pragma mark Init/Dealloc

-(id)init{
	if ((self = [super init])) {
		//self.tableCells = [NSMutableArray array];
	}
	return self;
}

-(void)dealloc{
	[userGuid release];
	[userEmail release];
	[userPassword release];
	[userFirstName release];
	[userSecondName release];
	
	[super dealloc];
}

-(void)decodeDictionary:(NSDictionary*)dictionary{	
	self.userGuid = [dictionary objectForKey: [Preferences userGuidAttrName]];
	self.userEmail = [dictionary objectForKey: [Preferences userEmailAttrName]];
	self.userPassword = [dictionary objectForKey: [Preferences userPasswordAttrName]];
	self.userFirstName = [dictionary objectForKey: [Preferences userFirstNameAttrName]];
	self.userSecondName = [dictionary objectForKey: [Preferences userSecondNameAttrName]];
}

-(void)encodeDictionary:(NSMutableDictionary*)dictionary{	
	[dictionary setObject:self.userGuid forKey:[Preferences userGuidAttrName]];
	[dictionary setObject:self.userEmail forKey:[Preferences userEmailAttrName]];
	[dictionary setObject:self.userPassword forKey:[Preferences userPasswordAttrName]];
	[dictionary setObject:self.userFirstName forKey:[Preferences userFirstNameAttrName]];
	[dictionary setObject:self.userSecondName forKey:[Preferences userSecondNameAttrName]];
}


@end
