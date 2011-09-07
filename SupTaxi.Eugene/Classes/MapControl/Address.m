//
//  Address.m
//  SupTaxi
//
//  Created by Eugene Zavalko on 06.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "Address.h"


@implementation Address

@synthesize addressId;
@synthesize addressName;
@synthesize address;
@synthesize longitude;
@synthesize latitude;
@synthesize addressType;

-(void)initWithGoogleResultPlacemark:(GoogleResultPlacemark *)placeMark{
	if (![[placeMark shortAddress] isEqualToString:@""]) {
		[self setAddress:[[placeMark shortAddress] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	}
		[self setLatitude:[NSNumber numberWithDouble:placeMark.coordinate.latitude]];
		[self setLongitude:[NSNumber numberWithDouble:placeMark.coordinate.longitude]];
		if ([[self addressName] isEqualToString:@""])
			[self setAddressName:[placeMark name]];
}

-(GoogleResultPlacemark *)googleResultPlacemark{
	CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[self latitude] doubleValue], [[self longitude] doubleValue]);
	GoogleResultPlacemark *placeMark = [[GoogleResultPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
	[placeMark setShortAddress:[self address]];
	[placeMark setName:[self addressName]];
	return [placeMark autorelease];
}

-(id)inithWithId:(NSInteger) addrId name:(NSString*)name address:(NSString*)addressString type:(NSInteger)type lon:(double)lon lat:(double)lat
{
	self = [super init];
    if (self != nil) {
		[self setAddressId:addrId];
		[self setAddress:addressString];
		[self setAddressName:name];
		[self setAddressType:type];
		[self setLatitude:[NSNumber numberWithDouble:lat]];
		[self setLongitude:[NSNumber numberWithDouble:lon]];
	}
	return self;
}

- (void)dealloc
{
    [addressName release];
	[address release];
	[latitude release];
	[longitude release];
    [super dealloc];
}

@end
