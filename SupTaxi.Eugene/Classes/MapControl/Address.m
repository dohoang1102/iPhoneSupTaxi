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
@synthesize addressArea;

-(void)initWithGoogleResultPlacemark:(GoogleResultPlacemark *)placeMark{
	if (![[placeMark shortAddress] isEqualToString:@""]) {
		[self setAddress:[[placeMark shortAddress] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	}
    [self setAddressArea:[placeMark cityArea]];
	[self setLatitude:[NSNumber numberWithDouble:placeMark.coordinate.latitude]];
	[self setLongitude:[NSNumber numberWithDouble:placeMark.coordinate.longitude]];
	if ([[self addressName] isEqualToString:@""])
		[self setAddressName:[placeMark name]];
}

-(GoogleResultPlacemark *)googleResultPlacemark{
	if ([self.latitude doubleValue] == 0 || [self.longitude doubleValue] == 0)
		return nil;
	CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[self latitude] doubleValue], [[self longitude] doubleValue]);
	GoogleResultPlacemark *placeMark = [[GoogleResultPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
	[placeMark setShortAddress:[self address]];
	[placeMark setName:[self addressName]];
    [placeMark setCityArea:[self addressArea]];
    [placeMark setCoordinatesInitialized:YES];
	return [placeMark autorelease];
}

-(id)initWithId:(NSInteger) addrId name:(NSString*)name address:(NSString*)addressString addressArea:(NSString*)area type:(NSInteger)type lon:(double)lon lat:(double)lat
{
	self = [super init];
    if (self != nil) {
		[self setAddressId:addrId];
		[self setAddress:addressString];
		[self setAddressName:name];
		[self setAddressType:type];
        [self setAddressArea:area];
		[self setLatitude:[NSNumber numberWithDouble:lat]];
		[self setLongitude:[NSNumber numberWithDouble:lon]];
	}
	return self;
}

-(void)initiateWithId:(NSInteger) addrId name:(NSString*)name address:(NSString*)addressString addressArea:(NSString*)area type:(NSInteger)type lon:(double)lon lat:(double)lat
{
    [self setAddressId:addrId];
    [self setAddress:addressString];
    [self setAddressName:name];
    [self setAddressType:type];
    [self setAddressArea:area];
    [self setLatitude:[NSNumber numberWithDouble:lat]];
}

- (void)dealloc
{
    [addressArea release];
    [addressName release];
	[address release];
	[latitude release];
	[longitude release];
    [super dealloc];
}

@end
