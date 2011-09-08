//
//  Preferences.m
//  SupTaxi
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

@synthesize notFirstRun;
@synthesize userHasContract;
@synthesize userHasPrefered;
@synthesize userHasRegularOrder;

@synthesize userContractNumber;
@synthesize userContractCustomer;
@synthesize userContractCarrier;

+(NSString*)notFirstRunAttrName{
	return @"notFirstRun";
}

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

+(NSString*)userHasContractAttrName{
	return @"userHasContract";
}
+(NSString*)userHasPreferedAttrName{
	return @"userHasPrefered";
}
+(NSString*)userHasRegularOrderAttrName{
	return @"userHasRegularOrder";
}

+(NSString*)userContractNumberAttrName{
	return @"userContractNumber";
}
+(NSString*)userContractCustomerAttrName{
	return @"userContractCustomer";
}
+(NSString*)userContractCarrierAttrName{
	return @"userContractCarrier";
}


#pragma mark Init/Dealloc

-(id)init{
	if ((self = [super init])) {}
	return self;
}

-(void)dealloc{
	[userGuid release];
	[userEmail release];
	[userPassword release];
	[userFirstName release];
	[userSecondName release];
	
	[userContractNumber release];
	[userContractCustomer release];
	[userContractCarrier release];
	
	[super dealloc];
}

-(void)decodeDictionary:(NSDictionary*)dictionary{	
	self.notFirstRun = [[dictionary valueForKey: [Preferences notFirstRunAttrName]] boolValue];
	
	self.userGuid = [dictionary objectForKey: [Preferences userGuidAttrName]];
	self.userEmail = [dictionary objectForKey: [Preferences userEmailAttrName]];
	self.userPassword = [dictionary objectForKey: [Preferences userPasswordAttrName]];
	self.userFirstName = [dictionary objectForKey: [Preferences userFirstNameAttrName]];
	self.userSecondName = [dictionary objectForKey: [Preferences userSecondNameAttrName]];
	
	self.userHasContract = [[dictionary valueForKey: [Preferences userHasContractAttrName]] boolValue];
	self.userHasPrefered = [[dictionary valueForKey: [Preferences userHasPreferedAttrName]] boolValue];
	self.userHasRegularOrder = [[dictionary valueForKey: [Preferences userHasRegularOrderAttrName]] boolValue];
	
	self.userContractNumber = [dictionary objectForKey: [Preferences userContractNumberAttrName]];
	self.userContractCustomer = [dictionary objectForKey: [Preferences userContractCustomerAttrName]];
	self.userContractCarrier = [dictionary objectForKey: [Preferences userContractCarrierAttrName]];
	
}

-(void)encodeDictionary:(NSMutableDictionary*)dictionary{	
	[dictionary setValue:[NSString stringWithFormat:@"%i", self.notFirstRun]  forKey:[Preferences notFirstRunAttrName]];
	
	[dictionary setObject:self.userGuid forKey:[Preferences userGuidAttrName]];
	[dictionary setObject:self.userEmail forKey:[Preferences userEmailAttrName]];
	[dictionary setObject:self.userPassword forKey:[Preferences userPasswordAttrName]];
	[dictionary setObject:self.userFirstName forKey:[Preferences userFirstNameAttrName]];
	[dictionary setObject:self.userSecondName forKey:[Preferences userSecondNameAttrName]];
	
	[dictionary setValue:[NSString stringWithFormat:@"%i",self.userHasContract] forKey:[Preferences userHasContractAttrName]];
	[dictionary setValue:[NSString stringWithFormat:@"%i",self.userHasPrefered] forKey:[Preferences userHasPreferedAttrName]];
	[dictionary setValue:[NSString stringWithFormat:@"%i",self.userHasRegularOrder] forKey:[Preferences userHasRegularOrderAttrName]];
	
	[dictionary setObject:self.userContractNumber forKey:[Preferences userContractNumberAttrName]];
	[dictionary setObject:self.userContractCustomer forKey:[Preferences userContractCustomerAttrName]];
	[dictionary setObject:self.userContractCarrier forKey:[Preferences userContractCarrierAttrName]];
}


@end
