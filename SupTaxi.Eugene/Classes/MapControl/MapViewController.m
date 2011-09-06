//
//  MapViewController.m
//  TestMapView
//
//  Created by DarkAn on 9/2/11.
//  Copyright 2011 DNK. All rights reserved.
//

#import "MapViewController.h"
#import "JSONKit.h"

@implementation MapViewController

#pragma mark Properties

@synthesize mapView;

@synthesize mapViewSearchBar;

@synthesize routeView;
@synthesize routes;
@synthesize lineColor;
@synthesize distance;
@synthesize time;
@synthesize googleManager;

-(void)setMapViewSearchBar:(MapViewBaseBar *)theMapViewSearchBar{
	[theMapViewSearchBar retain];
	[[mapViewSearchBar view] removeFromSuperview];
	[mapViewSearchBar setDelegate:nil];
	[mapViewSearchBar release];
	mapViewSearchBar = theMapViewSearchBar;
	
	if (mapViewSearchBar) {
		CGRect sbFrame = CGRectMake(0, 0, self.view.frame.size.width, mapViewSearchBar.view.frame.size.height);
		[[mapViewSearchBar view] setFrame:sbFrame];
		[[mapViewSearchBar view] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
		[[self view] addSubview:[mapViewSearchBar view]];
		mapViewSearchBar.delegate = self;
	}
}

#pragma mark Init/Dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	[time release];
	[distance release];
	[routeView release];
	[routes release];
	[lineColor release];
	
	[mapViewSearchBar release];

	[mapView release];
	[googleManager release];
	
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)initPreferences{
	[[self view] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	
	routeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mapView.frame.size.width, mapView.frame.size.height)];
	[routeView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	routeView.userInteractionEnabled = NO;
	[mapView addSubview:routeView];
	
	self.lineColor = [UIColor colorWithRed:0.7 green:0 blue:0 alpha:0.5];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	[self initPreferences];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Helping Methods

-(void) updateRouteView {
	CGContextRef context = 	CGBitmapContextCreate(nil, 
												  routeView.frame.size.width, 
												  routeView.frame.size.height, 
												  8, 
												  4 * routeView.frame.size.width,
												  CGColorSpaceCreateDeviceRGB(),
												  kCGImageAlphaPremultipliedLast);
	
	CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
	CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
	CGContextSetLineWidth(context, 3.0);
	
	for(int i = 0; i < routes.count; i++) {
		CLLocation* location = [routes objectAtIndex:i];
		CGPoint point = [mapView convertCoordinate:location.coordinate toPointToView:routeView];
		
		if(i == 0) {
			CGContextMoveToPoint(context, point.x, routeView.frame.size.height - point.y);
		} else {
			CGContextAddLineToPoint(context, point.x, routeView.frame.size.height - point.y);
		}
	}
	
	CGContextStrokePath(context);
	
	CGImageRef image = CGBitmapContextCreateImage(context);
	UIImage* img = [UIImage imageWithCGImage:image];
	
	routeView.image = img;
	CGContextRelease(context);
	
}

#pragma mark MapViewSearchBarDelegate

-(void)setSelfLocationSearchEnabled:(BOOL)enabled{
	[self.mapView setShowsUserLocation:enabled];
}

-(void)showPointsOnMap:(NSArray *)placeMarks{
	[mapView removeAnnotations:[mapView annotations]];
	
	if ([placeMarks count] == 0)
		return;
	[mapView addAnnotations:placeMarks];

	//searching center between our placemarks
	CLLocationDegrees latitude = 0;
	CLLocationDegrees longtitude = 0;
	for (GoogleResultPlacemark *placeMark in placeMarks) {
		latitude += placeMark.coordinate.latitude;
		longtitude += placeMark.coordinate.longitude;
	}
	latitude /= [placeMarks count];
	longtitude /= [placeMarks count];
	CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake(latitude, longtitude);
	
	//calculating scale factor
	CLLocationDegrees latitudeMapDist = 0.001;
	CLLocationDegrees longtitudeMapDist = 0.001;
	if ([placeMarks count] > 1) {
		latitudeMapDist = 0;
		longtitudeMapDist = 0;
		for (GoogleResultPlacemark *placeMark in placeMarks) {
			CLLocationDegrees latDiff = ABS(placeMark.coordinate.latitude - centerCoord.latitude)*2;
			CLLocationDegrees lonDiff = ABS(placeMark.coordinate.longitude - centerCoord.longitude)*2;
			if (latDiff > latitudeMapDist)
				latitudeMapDist = latDiff;
			if (lonDiff > longtitudeMapDist)
				longtitudeMapDist = lonDiff;
		}

		latitudeMapDist = latitudeMapDist + latitudeMapDist*4/100;	//increase at 4%
		longtitudeMapDist = longtitudeMapDist + longtitudeMapDist*4/100;	//increase at 4%
	}
	
	//showing routes
	if ([placeMarks count] > 1) {
		GoogleResultPlacemark *from = [placeMarks objectAtIndex:0];
		GoogleResultPlacemark *to = [placeMarks objectAtIndex:1];

		googleManager = [[GoogleServiceDirectionsManager alloc] initWithDelegate:self];
		[self.googleManager calculateRoutesFrom:from.coordinate to:to.coordinate];
	}
	
	//scaling and moving map
	MKCoordinateRegion region = MKCoordinateRegionMake(centerCoord, MKCoordinateSpanMake(latitudeMapDist, longtitudeMapDist));
	[mapView setRegion:region animated:YES];
}

#pragma mark MKMapViewDelegate

-(MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id<MKAnnotation>)annotation{
	if ([annotation isKindOfClass:[MKUserLocation class]]) {
		NSString *userLocIdentifier = @"userLocation";
		MKAnnotationView *view = [theMapView dequeueReusableAnnotationViewWithIdentifier:userLocIdentifier];
		if (!view) {
			view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:userLocIdentifier];
		}
		return view;
	}
	
	NSString *identifier = @"annotation";
	MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
	if (!annotationView) {
		annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
	} else
		[annotationView setAnnotation:annotation];
	[annotationView setPinColor:[(GoogleResultPlacemark *)annotation colorForPin]];
	[annotationView setCanShowCallout:YES];
	
	return annotationView;
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
	routeView.hidden = YES;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
	[self updateRouteView];
	routeView.hidden = NO;
	[routeView setNeedsDisplay];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
	NSLog(@"User location found");
	[self.mapViewSearchBar onSelfLocationFound:userLocation];
}

-(void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
	
}

#pragma mark GoogleServiceDirectionsManagerDelegate

-(void)onRoutesCalculated:(NSArray *)newRoutes distance:(NSString *)newDistance time:(NSString *)newTime{
	self.googleManager = nil;
	self.routes = newRoutes;
	self.distance = newDistance;
	self.time = newTime;
	[self updateRouteView];
}

-(void)onRequestFail{
	self.googleManager = nil;
	self.routes = [NSArray array];
	self.distance = @"";
	self.time = @"";
	[self updateRouteView];
}

#pragma mark Events


@end
