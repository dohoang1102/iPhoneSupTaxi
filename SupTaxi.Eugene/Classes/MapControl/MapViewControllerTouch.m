//
//  MapViewControllerTouch.m
//  SupTaxi
//
//  Created by Alex Pavlysh on 9/21/11.
//  Copyright (c) 2011 DNK. All rights reserved.
//

#import "MapViewControllerTouch.h"
#import "BarButtonItemGreenColor.h"

@implementation MapViewControllerTouch

#pragma mark Properties

@synthesize okButton;

@synthesize tapInterceptor;
@synthesize pointFrom;
@synthesize pointTo;
@synthesize selectionDelegate;
@synthesize googleServiceManager;

-(NSArray *)pointsArray{
	NSMutableArray *retVal = [NSMutableArray array];
	if (pointFrom != nil)
		[retVal addObject:pointFrom];
	if (pointTo != nil)
		[retVal addObject:pointTo];
	return retVal;
}

#pragma mark Init/Dealloc

-(void)dealloc{
	[googleServiceManager setDelegate:nil];
	[googleServiceManager release];
	[okButton release];
	[tapInterceptor release];
	
	[pointFrom release];
	[pointTo release];
	
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (!nibNameOrNil)
		nibNameOrNil = @"MapViewController";
	
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];

	[self moveToMoscow];
}

#pragma mark Helping Functions

-(void)moveToMoscow{
	//move to moscow
	CLLocationCoordinate2D center = CLLocationCoordinate2DMake(55.755786, 37.617633);
	MKCoordinateSpan span = MKCoordinateSpanMake(0.5, 0.5);
	MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
	[[self mapView] setRegion:region animated:NO];
}

-(void)addGestureRecognizer{
	self.tapInterceptor = [[[WildCardGestureRecognizer alloc] init] autorelease];
	
	self.tapInterceptor.mapView = self.mapView;
	self.tapInterceptor.controller = self;

	[self.mapView addGestureRecognizer:self.tapInterceptor];
}

-(void)initPreferences{
	UIColor *color = [UIColor colorWithRed:16.0/255.0 green:79.0/255.0 blue:13.0/255.0 alpha:1];
	
	[super initPreferences];
	[self addGestureRecognizer];
	
	self.okButton = [UIBarButtonItem barButtonItemWithTint:color andTitle:@"OK" andTarget:self andSelector:@selector(onOk:)];
	self.navigationItem.rightBarButtonItem = self.okButton;
	
	UIBarButtonItem *backButton = [UIBarButtonItem barButtonItemWithTint:color andTitle:@"Назад" andTarget:self andSelector:@selector(onBack:)];
	self.navigationItem.leftBarButtonItem = backButton;
}

-(void)startPlacemarkSearch:(GoogleResultPlacemark *)placeMark{
	self.googleServiceManager = [[[GoogleServiceManager alloc] initWithDelegate:self] autorelease];
	[self.googleServiceManager searchCoordinatesbyLongtitude:placeMark.coordinate.longitude latitude:placeMark.coordinate.latitude];
}

-(void)setPlaceAt:(NSValue *)pointValue{
	CLLocationCoordinate2D coord = [self.mapView convertPoint:[pointValue CGPointValue] toCoordinateFromView:[self view]];
	
	
	
	GoogleResultPlacemark *placeMark = [GoogleResultPlacemark googleResultPlaceMarkWithCoordinates:coord 
																					  isStartPoint:(pointFrom == nil)];
	
	[self startPlacemarkSearch:placeMark];
}

#pragma mark GoogleServiceManagerDelegate

-(void)onRequestFail{
	NSLog(@"Was unable to find this address");
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Не удалось найти данный адресс" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
	
	self.googleServiceManager = nil;
}

-(void)onCoordinateFound:(id)placeMarkId{
	self.googleServiceManager = nil;
	
	if (self.mapViewSearchBar) {
		[self.mapViewSearchBar setFoundPlaceMark:placeMarkId];
		[self showPointsOnMap:[NSArray arrayWithObject:placeMarkId] shouldResizeMap:NO];
	} else {
		if (!pointFrom) {
			self.pointFrom = placeMarkId;
			[self.pointFrom setStartPoint:YES];
		} else {
			self.pointTo = placeMarkId;
			[self.pointTo setStartPoint:NO];
		}
		
		[self showPointsOnMap:self.pointsArray shouldResizeMap:NO];
	}
}

#pragma mark MKMapViewDelegate

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
	if (self.mapViewSearchBar || [self.tapInterceptor justAddedPlacemark]) {
		[mapView deselectAnnotation:view.annotation animated:YES];
		return;
	}
	//remove placemark
	GoogleResultPlacemark *placeMark = (GoogleResultPlacemark *)view.annotation;
	if (placeMark == pointFrom) {
		self.pointFrom = nil;
	} else if (placeMark == pointTo) {
		self.pointTo = nil;
	}
	
	[self showPointsOnMap:[self pointsArray] shouldResizeMap:NO];
}

#pragma mark Events

-(void)onOk:(id)sender{
	[self.navigationController popViewControllerAnimated:NO];
	[selectionDelegate onPlaceMarksSelected:[self pointsArray]];
}

-(void)onBack:(id)sender{
	[self.navigationController popViewControllerAnimated:YES];
}

@end
