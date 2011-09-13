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
#define POSTAL_CODE @"postal_code"	
#define SUB_ADMINISTRATIVE @"administrative_area_level_2"	
#define SUB_CITY @"sublocality"
#define SUB_STREET @"street_number"
#define STREET_ADDRESS @"street_address"
#define STREET @"route"

@implementation GoogleResultPlacemark

#pragma mark Properties

@synthesize cityArea;
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
    if (shortAddress) {
        return shortAddress;
    }
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
    [cityArea release];
	[cityRegion release];
	[houseNumber release];
	[shortAddress release];
	[name release];
	[super dealloc];
}

-(void)extendHouseNumber:(NSString *)value{
	if (!value || [value isEqualToString:@""])
		return;
	
	if (houseNumber && ![houseNumber isEqualToString:@""]){
		self.houseNumber = [self.houseNumber stringByAppendingString:@", "];
		self.houseNumber = [self.houseNumber stringByAppendingString:value];
	}
	else
		self.houseNumber = value;
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
        //NSLog(@"GET %@ = '%@'", (NSString *)kABPersonAddressStateKey, value);
		if ([types containsObject:STATE]) {
			[addressDict setValue:value forKey:(NSString *)kABPersonAddressStateKey];
			NSLog(@"set %@ = '%@'", (NSString *)kABPersonAddressStateKey, value);
		} else if ([types containsObject:COUNTRY]) {
			[addressDict setValue:value forKey:(NSString *)kABPersonAddressCountryKey];
			NSLog(@"set %@ = '%@'", (NSString *)kABPersonAddressCountryKey, value);
		} else if ([types containsObject:COUNTRY_CODE]) {
			[addressDict setValue:value forKey:(NSString *)kABPersonAddressCountryCodeKey];
			NSLog(@"set %@ = '%@'", (NSString *)kABPersonAddressCountryCodeKey, value);
		} else if ([types containsObject:CITY]) {
			[addressDict setValue:value forKey:(NSString *)kABPersonAddressCityKey];
			NSLog(@"set %@ = '%@'", (NSString *)kABPersonAddressCityKey, value);
		} else if ([types containsObject:POSTAL_CODE]){
			[addressDict setValue:value forKey:(NSString *)kABPersonAddressZIPKey];
			NSLog(@"set %@ = '%@'", (NSString *)kABPersonAddressZIPKey, value);
		}
		else if ([types containsObject:SUB_ADMINISTRATIVE]){
			[self setCityArea:value];
            NSLog(@"set %@ = '%@'", @"Area", value);
        } else if ([types containsObject:SUB_CITY]) {
			[self setCityRegion:value];
			NSLog(@"set %@ = '%@'", @"CityRegion", value);
		} else if ([types containsObject:SUB_STREET]) {
			[self extendHouseNumber:value];
			NSLog(@"set %@ = '%@'", @"HoseNumber", value);
		} else if ([types containsObject:STREET_ADDRESS]) {
			[self extendHouseNumber:value];
			NSLog(@"set %@ = '%@'", @"HoseNumber", value);
		} else if ([types containsObject:STREET]) {
			[addressDict setValue:value forKey:(NSString *)kABPersonAddressStreetKey];
			NSLog(@"set %@ = '%@'", (NSString *)kABPersonAddressStreetKey, value);
		} else
			NSLog(@"Can't assign anywhere '%@' with types %@", value, types);
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
	
    retVal.cityArea = self.cityArea;
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
