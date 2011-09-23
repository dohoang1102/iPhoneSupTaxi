//
//  GoogleServiceDirectionsManager.m
//  SupTaxi
//
//  Created by DarkAn on 9/6/11.
//  Copyright 2011 DNK. All rights reserved.
//

#import "GoogleServiceDirectionsManager.h"
#import "JSONKit.h"

@implementation GoogleServiceDirectionsManager

#pragma mark Properties

@synthesize delegate;
@synthesize dataFromConnection;

#pragma mark Init/dealloc

-(id)initWithDelegate:(id<GoogleServiceDirectionsManagerDelegate>)googleServiceManagerDelegate{
	if ((self = [super init])) {
		self.delegate = googleServiceManagerDelegate;
	}
	return self;
}

-(void)dealloc{
	
	[dataFromConnection release];
	
	[super dealloc];
}

#pragma mark Helping Methods

-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded {
	[encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
								options:NSLiteralSearch
								  range:NSMakeRange(0, [encoded length])];
	NSInteger len = [encoded length];
	NSInteger index = 0;
	NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
	NSInteger lat=0;
	NSInteger lng=0;
	while (index < len) {
		NSInteger b;
		NSInteger shift = 0;
		NSInteger result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lat += dlat;
		shift = 0;
		result = 0;
		if (index < len)
			do {
				b = [encoded characterAtIndex:index++] - 63;
				result |= (b & 0x1f) << shift;
				shift += 5;
			} while (b >= 0x20);
		NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lng += dlng;
		NSNumber *latitude = [[[NSNumber alloc] initWithFloat:lat * 1e-5] autorelease];
		NSNumber *longitude = [[[NSNumber alloc] initWithFloat:lng * 1e-5] autorelease];
		//printf("[%f,", [latitude doubleValue]);
		//printf("%f]", [longitude doubleValue]);
		CLLocation *loc = [[[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]] autorelease];
		[array addObject:loc];
	}
	
	return array;
}

-(void)decodeReceivedData:(NSData *)data{
	NSDictionary *results = (NSDictionary *)[[JSONDecoder decoder] objectWithData:data];
	
	NSArray *routesArray = [results valueForKeyPath:@"routes.overview_polyline.points"];
	if ([routesArray count] == 0) {
		NSLog(@"there is no route between this points");
		[delegate onRoutesCalculated:[NSArray array] distance:@"" time:@""];
		return;
	}
	NSString *routeLine = [routesArray objectAtIndex:0];
	NSString *distance = [[[results valueForKeyPath:@"routes.legs.distance.text"] objectAtIndex:0] objectAtIndex:0];
	NSString *time = [[[results valueForKeyPath:@"routes.legs.duration.text"] objectAtIndex:0] objectAtIndex:0];
	
	NSArray *routes = [self decodePolyLine:[routeLine mutableCopy]];
	[delegate onRoutesCalculated:routes distance:distance time:time];
}

-(void) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t {
	self.dataFromConnection = [NSMutableData data];
	NSString* saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
	NSString* daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
	
	NSString *apiUrlStr = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&language=ru&units=metric&sensor=false", saddr, daddr];
	NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
	NSLog(@"api url: %@", apiUrl);
	
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:apiUrl];
	
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
    [connection release];
    [request release];
}


#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{   
	[dataFromConnection appendData:data];
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
