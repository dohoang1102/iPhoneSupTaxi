//
//  MapViewBaseBar.m
//  SupTaxi
//
//  Created by DarkAn on 9/4/11.
//  Copyright 2011 DNK. All rights reserved.
//

#import "MapViewBaseBar.h"


//#define ADD_BEFORE_ADDRESS @"Москва ";
#define ADD_BEFORE_ADDRESS @"Россия Москва ";

@implementation MapViewBaseBar

#pragma mark Properties

@synthesize hideButton;

@synthesize hidden;

@synthesize delegate;
@synthesize knownAddressesDelegate;
@synthesize googleManager;

@synthesize requestedCurrentLocation;
@synthesize blinkTimer;
@synthesize blinkCount;

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
	[blinkTimer invalidate];
	[blinkTimer release];
	
	[googleManager release];
	[hideButton release];
	
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.hidden = NO;
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

-(void)resignEditFields{
	//here to all edit fields should be sent resignFirstResponder
}

-(NSArray *)placeMarks{
	return [NSArray array];
}

-(void)setFoundPlaceMark:(GoogleResultPlacemark *)placeMark{
	
}

-(void)initWithSelfLocation{
	//should set some placeMark to self location and enable at delegate setSelfLocationSearchEnabled:(BOOL)enabled
}

-(void)onSelfLocationFound:(MKUserLocation *)location{
	//should update selfLocation placemark and reload map	
}

-(BOOL)validate{
	return YES;
}

-(void)clearData{
	
}

-(NSString *)nameForKnownAdderessByLocation:(CLLocationCoordinate2D)coordinate{
	if (knownAddressesDelegate == nil)
		return nil;
	for (GoogleResultPlacemark *placeMark in [knownAddressesDelegate knownAddresses])
		if (placeMark.coordinate.longitude == coordinate.longitude 
			&& placeMark.coordinate.latitude == coordinate.latitude) {
			return [placeMark name];
		}

	return nil;
}

#pragma mark HideButton blinking


-(void)scheduleBlinkTimer{
	self.blinkTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(onChangeHiddenButtonColor) userInfo:nil repeats:NO];
}

-(void)onChangeHiddenButtonColor{
	UIColor *newColor = self.blinkCount % 2 == 1 ? [UIColor blackColor] : [UIColor cyanColor];
	self.blinkCount++;
	[hideButton setBackgroundColor:newColor];
	if (self.blinkCount < 8)
		[self scheduleBlinkTimer];
	else
		self.blinkTimer = nil;
}

-(void)setupBlinkTimer{
	self.blinkCount = 0;
	[self scheduleBlinkTimer];
}

-(void)hide{
	float hiddenHeight = hideButton.frame.origin.y;
	CGRect curFrame = self.view.frame;
	if (hidden || curFrame.origin.y <= -hiddenHeight)
		return;
	
	[self resignEditFields];
	
	[UIView beginAnimations:@"Hiding searchBar" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(setupBlinkTimer)];
	CGRect newSearchBarFrame = CGRectMake(curFrame.origin.x, -hiddenHeight, curFrame.size.width, curFrame.size.height);
	[self.view setFrame:newSearchBarFrame];
	hidden = YES;
	[UIView commitAnimations];
}

-(void)show{
	CGRect curFrame = self.view.frame;
	if (curFrame.origin.y >= 0)
		return;
	
	[UIView beginAnimations:@"Showing searchBar" context:nil];
	
	CGRect newSearchBarFrame = CGRectMake(curFrame.origin.x, 0, curFrame.size.width, curFrame.size.height);
	[self.view setFrame:newSearchBarFrame];
	hidden = NO;
	[UIView commitAnimations];
}

-(void)onShowRoute{
	NSLog(@"Show points at map");
	[delegate showPointsOnMap:[self placeMarks] shouldResizeMap:YES];
}

-(void)startAddressSearch:(NSString *)address{
    GoogleServiceManager * gmanager = [[GoogleServiceManager alloc] initWithDelegate:self];
	self.googleManager = gmanager;
    [gmanager release];
	NSString *beforeAddress = ADD_BEFORE_ADDRESS;
	NSString *addressToFind = [NSString stringWithFormat:@"%@%@", beforeAddress, address];
	[self.googleManager searchCoordinatesForAddress:addressToFind];
}

-(void)startPlacemarkSearch:(GoogleResultPlacemark *)placeMark{
	self.googleManager = [[[GoogleServiceManager alloc] initWithDelegate:self] autorelease];
	[self.googleManager searchCoordinatesbyLongtitude:placeMark.coordinate.longitude latitude:placeMark.coordinate.latitude];
}

#pragma mark GoogleServiceManagerDelegate

-(void)onRequestFail{
	NSLog(@"Was unable to find this address");
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Не удалось найти данный адресс" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
	
	self.googleManager = nil;
}

-(void)onCoordinateFound:(id)placeMarkId{
	self.googleManager = nil;
	
	[self setFoundPlaceMark:placeMarkId];

	[self onShowRoute];
}

#pragma mark events

-(IBAction)onHidePressed:(id)sender{
	if (hidden)
    {
        [((UIButton*)sender) setTitle:@"Скрыть" forState:UIControlStateNormal];
		[self show];
	}else{
        [((UIButton*)sender) setTitle:@"Показать" forState:UIControlStateNormal];
		[self hide];
    }
}


@end
