//
//  GoogleResultPlacemark.m
//  TestMapView
//
//  Created by DarkAn on 9/3/11.
//  Copyright 2011 DNK. All rights reserved.
//

#import "GoogleResultPlacemark.h"
#import <AddressBook/AddressBook.h>

#define STATE @"administrative_area_level_1"
#define COUNTRY @"country"
#define COUNTRY_CODE @""	//??
#define CITY @"locality"
#define POSTAL_CODE @"postal"	//??
#define SUB_ADMINISTRATIVE @"administrative_area_level_3"	
#define SUB_CITY @"sublocality"
#define SUB_STREET @"street_number"
#define STREET @"route"

@implementation GoogleResultPlacemark

#pragma mark Properties

@synthesize cityRegion;
@synthesize houseNumber;
@synthesize shortAddress;
@synthesize name;

@synthesize startPoint;
@synthesize selfLocation;
@synthesize coordinatesInitialized;

-(NSString *)name{
	if (self.selfLocation) {
		return @"Мое месторасположение";
	}
	if ([self isNameCustom]) {
		return name;
	}
	return [self shortAddress];
}

-(NSString *)shortAddress{
	NSString *retVal = @"";
	if (self.thoroughfare)
		retVal = self.thoroughfare;
	if (self.houseNumber){
		NSString *delimiter = @"";
		if (![retVal isEqualToString:@""])
			delimiter = @", ";
		retVal = [NSString stringWithFormat:@"%@%@%@", retVal, delimiter, self.houseNumber];
	}
	return retVal;
}

-(BOOL)isNameCustom{
	return (name && ![name isEqualToString:@""]);
}

#pragma mark Init/Dealloc

+(id)googleResultPlaceMarkForSelfLocation{
	CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(0, 0);
	GoogleResultPlacemark *retVal = [[GoogleResultPlacemark alloc] initWithCoordinate:coord addressDictionary:nil];
	[retVal setSelfLocation:YES];
	[retVal setStartPoint:YES];
	[retVal setCoordinatesInitialized:NO];
	return [retVal autorelease];
}

+(id)googleResultPlaceMarkForSelfLocationWithCoordinates:(CLLocationCoordinate2D)coord startPoint:(BOOL)isStartPoint{
	GoogleResultPlacemark *retVal = [[GoogleResultPlacemark alloc] initWithCoordinate:coord addressDictionary:nil];
	[retVal setSelfLocation:YES];
	[retVal setStartPoint:isStartPoint];
	[retVal setCoordinatesInitialized:YES];
	return [retVal autorelease];
}

+(id)googleResultPlacemarkWithResponceDictionary:(NSDictionary *)responce{
	GoogleResultPlacemark *retVal = [[GoogleResultPlacemark alloc] initWithResponceDictionary:responce];
	return [retVal autorelease];
}

+(id)googleResultPlaceMarkByGoogleResultPlacemark:(GoogleResultPlacemark *)placeMark{
	return [placeMark clone];
}

-(void)dealloc{
	[cityRegion release];
	[houseNumber release];
	[shortAddress release];
	[name release];
	[super dealloc];
}

-(id)initWithResponceDictionary:(NSDictionary *)responce{

	NSDictionary * coordinates = [responce valueForKeyPath:@"geometry.location"];
	double longitude = [[[coordinates valueForKey:@"lng"] objectAtIndex:0] doubleValue];
	double latitude = [[[coordinates valueForKey:@"lat"] objectAtIndex:0] doubleValue];
	CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);
	
	NSArray *addressComponents = [[responce valueForKey:@"address_components"] objectAtIndex:0];
	NSMutableDictionary *addressDict = [NSMutableDictionary dictionary];
	
	for (NSDictionary *dict in addressComponents) {
		NSArray *types = [dict valueForKey:@"types"];
		NSString *value = [dict valueForKey:@"long_name"];
		if ([types containsObject:STATE])
			[addressDict setValue:value forKey:(NSString *)kABPersonAddressStateKey];
		else if ([types containsObject:COUNTRY])
			[addressDict setValue:value forKey:(NSString *)kABPersonAddressCountryKey];
		else if ([types containsObject:COUNTRY_CODE])
			[addressDict setValue:value forKey:(NSString *)kABPersonAddressCountryCodeKey];
		else if ([types containsObject:CITY])
			[addressDict setValue:value forKey:(NSString *)kABPersonAddressCityKey];
		else if ([types containsObject:POSTAL_CODE])
			[addressDict setValue:value forKey:(NSString *)kABPersonAddressZIPKey];
//		else if ([types containsObject:SUB_ADMINISTRATIVE])
//			[addressDict setValue:value forKey:(NSString *)kABPersonAddressCountryKey];
		else if ([types containsObject:SUB_CITY])
			[self setCityRegion:value];
		else if ([types containsObject:SUB_STREET])
			[self setHouseNumber:value];
		else if ([types containsObject:STREET])
			[addressDict setValue:value forKey:(NSString *)kABPersonAddressStreetKey];
	}
	
	if ((self = [super initWithCoordinate:coord addressDictionary:addressDict])) {
		//additional init;
		[self setCoordinatesInitialized:YES];
	}
	return self;

}

#pragma mark Helping functions

-(MKPinAnnotationColor)colorForPin{
	return startPoint ? MKPinAnnotationColorGreen : MKPinAnnotationColorPurple;
}

-(GoogleResultPlacemark *)clone{
	GoogleResultPlacemark *retVal = [[GoogleResultPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:self.addressDictionary];
	
	retVal.cityRegion = self.cityRegion;
	retVal.houseNumber = self.houseNumber;
	if ([self isNameCustom])
		retVal.name = self.name;
	retVal.startPoint = self.startPoint;
	retVal.selfLocation = self.selfLocation;
	retVal.coordinatesInitialized = self.coordinatesInitialized;
	
	return [retVal autorelease];
}

#pragma mark MKAnnotation Protocol

-(NSString *)title{
	NSString *retVal = name && [name length] > 0 ? [name stringByAppendingString:@" "] : @"";
	return [NSString stringWithFormat:@"%@%@", retVal, startPoint ? @"начало маршрута" : @"конец маршрута"];
}

-(NSString *)subtitle{
	return [self shortAddress];
}

@end
