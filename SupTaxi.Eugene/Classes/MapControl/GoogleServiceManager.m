//
//  GoogleServiceManager.m
//  TestMapView
//
//  Created by DarkAn on 9/2/11.
//  Copyright 2011 DNK. All rights reserved.
//

#import "GoogleServiceManager.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import "NSString+URLEncode.h"
#import "GoogleResultPlacemark.h"

#import "JSONKit.h"

@implementation GoogleServiceManager

#pragma mark Properties

@synthesize delegate;
@synthesize dataFromConnection;

#pragma mark Init/dealloc

-(id)initWithDelegate:(id)googleServiceManagerDelegate{
	if ((self = [super init])) {
		self.delegate = (id<GoogleServiceManagerDelegate>)googleServiceManagerDelegate;
	}
	return self;
}

-(void)dealloc{
	
	[dataFromConnection release];
	
	[super dealloc];
}

#pragma mark Public Methods

-(void)decodeReceivedData:(NSData *)data{
//	if (!data) {
//		NSLog(@"Can't connect to server");
//		[delegate onRequestFail];
//		return;
//	}
	NSLog(@"Received data");
	NSError *error = nil;
	NSDictionary *results = (NSDictionary *)[[JSONDecoder decoder] objectWithData:data];
	if (error) {
		NSLog(@"%@", [error description]);
		[delegate onRequestFail];
		return;
	}
	
	if (![results isKindOfClass:[NSDictionary class]] || ![[results valueForKey:@"status"] isEqual:@"OK"]) {
		NSLog(@"Status is not OK");
		[delegate onRequestFail];
		return;
	}
	
	NSDictionary *placeMarkDict = [results valueForKey:@"results"];
	GoogleResultPlacemark *placeMark = [GoogleResultPlacemark googleResultPlacemarkWithResponceDictionary:placeMarkDict];
	[delegate onCoordinateFound:placeMark];
}

-(void)searchCoordinatesbyLongtitude:(double)longitude latitude:(double)latitude{
	NSString *address = [NSString stringWithFormat:@"%f,%f", latitude, longitude];
	[self searchCoordinatesForAddress:address];
}

- (void) searchCoordinatesForAddress:(NSString *)inAddress
{
	self.dataFromConnection = [NSMutableData data];
    //Build the string to Query Google Maps.
	//http://maps.googleapis.com/maps/api/geocode/output?parameters
	
	NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true&language=ru", [inAddress URLEncodedString]];

    //Create NSURL string from a formate URL string.
    NSURL *url = [NSURL URLWithString:urlString];
	
    //Setup and start an async download.
    //Note that we should test for reachability!.
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	
	//try to do request in synchronous way
//	NSData *response = [NSData dataWithContentsOfURL:url];
//	[self decodeReceivedData:response];		
	
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
    [connection release];
    [request release];
}

#pragma mark NSURLConnectionDelegate

//It's called when the results of [[NSURLConnection alloc] initWithRequest:request delegate:self] come back.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{   
	[dataFromConnection appendData:data];
	//[self decodeReceivedData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	NSLog(@"Connection failed: %@", [error description]);
	self.dataFromConnection = nil;
	[delegate onRequestFail];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
	NSLog(@"Connection finished");
	[self decodeReceivedData:dataFromConnection];
	self.dataFromConnection = nil;
}

@end