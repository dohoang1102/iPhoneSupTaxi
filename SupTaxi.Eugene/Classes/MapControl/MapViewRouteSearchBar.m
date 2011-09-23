//
//  MapViewRouteSearchBar.m
//  SupTaxi
//
//  Created by DarkAn on 9/4/11.
//  Copyright 2011 DNK. All rights reserved.
//

#import "MapViewRouteSearchBar.h"
#import "AddressViewController.h"
#import "Address.h"
#import "SupTaxiAppDelegate.h"
#import	"RegisterViewController.h"

@implementation MapViewRouteSearchBar

@synthesize fromField;
@synthesize toField;
@synthesize fromAddressButton;
@synthesize timeField;
@synthesize carView;
@synthesize carImageView;
@synthesize carTypeLabel;
@synthesize daysView;
@synthesize daysField;

@synthesize placeMarkFrom;
@synthesize placeMarkTo;
@synthesize selfLocationPlacemark;

@synthesize currentTextField;
@synthesize currentFieldName;

@synthesize parentController;

@synthesize daysVisible;

-(void)setDaysVisible:(BOOL)daysVisibleVal{
	if (daysVisible == daysVisibleVal)
		return;
	
	daysVisible = daysVisibleVal;
	
	//moving CarView by Y
	float carViewY = daysVisible ? daysView.frame.origin.y + daysView.frame.size.height : daysView.frame.origin.y;
	[daysView setHidden:!daysVisible];
	[carView setFrame:CGRectMake(carView.frame.origin.x, carViewY, carView.frame.size.width, carView.frame.size.height)];
	
	//moving HideButton by Y
	float hideButtonY = carViewY + carView.frame.size.height;
	CGRect hideBtnFrame = self.hideButton.frame;
	[self.hideButton setFrame:CGRectMake(hideBtnFrame.origin.x, hideButtonY, hideBtnFrame.size.width, hideBtnFrame.size.height)];
	
	//Resizing View itself
	float newHeight = hideButtonY + self.hideButton.frame.size.height;
	CGRect curViewFrame = [self view].frame;
	[[self view] setFrame:CGRectMake(curViewFrame.origin.x, curViewFrame.origin.y, curViewFrame.size.width, newHeight)];
}

-(void)setPlaceMarkFrom:(GoogleResultPlacemark *)newPlaceMarkFrom{
	[newPlaceMarkFrom retain];
	[newPlaceMarkFrom setStartPoint:YES];
	[placeMarkFrom release];
	placeMarkFrom = newPlaceMarkFrom;
}

-(void)setPlaceMarkTo:(GoogleResultPlacemark *)newPlaceMarkTo{
	[newPlaceMarkTo retain];
	[newPlaceMarkTo setStartPoint:NO];
	[placeMarkTo release];
	placeMarkTo = newPlaceMarkTo;
}

#pragma mark Init/Dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		daysVisible = YES;
    }
    return self;
}

- (void)dealloc
{
	[placeMarkFrom release];
	[placeMarkTo release];
	[selfLocationPlacemark release];
	
	[fromField release];
	[toField release];
	[fromAddressButton release];
	[timeField release];
	[carView release];
	[carImageView release];
	[carTypeLabel release];
	[daysField release];
	[daysView release];
	
	[currentTextField release];
	[currentFieldName release];
	
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
	
	prefManager = [SupTaxiAppDelegate sharedAppDelegate].prefManager;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark Helping Methods

-(void)clearData{
	[self.fromField setText:@""];
	[self.toField setText:@""];
	[self.timeField setText:@""];
    [self.daysField setText:@""];
	self.placeMarkFrom = nil;
	self.placeMarkTo = nil;
	[self initWithSelfLocation];
	[self onShowRoute];
}

-(BOOL)validate{
    if ([self.fromField.text isEqualToString:@""] || [self.toField.text isEqualToString:@""]) {
		return NO;
	}
    /*
	if (self.placeMarkFrom == nil || ![self.placeMarkFrom coordinatesInitialized])
		return NO;
	if (self.placeMarkTo == nil || ![self.placeMarkTo coordinatesInitialized]) {
		return NO;
	}*/
	return YES;
}

-(void)resignEditFields{
	[fromField resignFirstResponder];
	[toField resignFirstResponder];
}

-(NSArray *)placeMarks{
	NSMutableArray *placemarks = [NSMutableArray array];
	if (self.placeMarkFrom && self.placeMarkFrom.coordinate.latitude != 0)
		[placemarks addObject:self.placeMarkFrom];
	if (self.placeMarkTo && self.placeMarkTo.coordinate.latitude != 0)
		[placemarks addObject:self.placeMarkTo];
	return placemarks;
}

-(void)setFoundPlaceMark:(GoogleResultPlacemark *)placeMark{
	if (self.currentFieldName)
		[placeMark setName:self.currentFieldName];
	if (self.requestedCurrentLocation) {
		if ([selfLocationPlacemark selfLocation]){			
			self.selfLocationPlacemark = [placeMark clone];
			[self.selfLocationPlacemark setSelfLocation:YES];
		}
		if ([placeMarkFrom selfLocation]){			
			self.placeMarkFrom = [placeMark clone];
			[self.placeMarkFrom setSelfLocation:YES];
		}
		if ([placeMarkTo selfLocation]) {
			self.placeMarkTo = [placeMark clone];
			[self.placeMarkTo setSelfLocation:YES];
		}
		
		self.requestedCurrentLocation = NO;
	} else if (self.currentTextField == fromField){
		self.placeMarkFrom = placeMark;
        if (![[placeMark name] isEqualToString:@""]) //
		[fromField setText:[placeMark name]];
	} else {
		self.placeMarkTo = placeMark;
        if (![[placeMark name] isEqualToString:@""]) //
		[toField setText:[placeMark name]];
	}
	self.currentTextField = nil;
	self.currentFieldName = nil;
}

-(void)initWithSelfLocation{
	if (!self.selfLocationPlacemark) {
		self.selfLocationPlacemark = [GoogleResultPlacemark googleResultPlaceMarkForSelfLocation];
	}
	self.placeMarkFrom = [GoogleResultPlacemark googleResultPlaceMarkForSelfLocation];
	[self.fromField setText:[self.placeMarkFrom name]];
	[self.delegate setSelfLocationSearchEnabled:YES];
}

-(void)onSelfLocationFound:(MKUserLocation *)location{
	GoogleResultPlacemark *newPlaceMark = nil;
	if (self.selfLocationPlacemark && [self.selfLocationPlacemark selfLocation]) {
		self.selfLocationPlacemark = [GoogleResultPlacemark googleResultPlaceMarkForSelfLocationWithCoordinates:location.coordinate 
																							 startPoint:self.selfLocationPlacemark.startPoint];
		newPlaceMark = self.selfLocationPlacemark;
	}
	if (self.placeMarkFrom && [self.placeMarkFrom selfLocation] && ![fromField isEditing]) {
		self.placeMarkFrom = [GoogleResultPlacemark googleResultPlaceMarkForSelfLocationWithCoordinates:location.coordinate 
																							 startPoint:self.placeMarkFrom.startPoint];
		newPlaceMark = self.placeMarkFrom;
	}
	if (self.placeMarkTo && [self.placeMarkTo selfLocation] && ![fromField isEditing]) {
		self.placeMarkTo = [GoogleResultPlacemark googleResultPlaceMarkForSelfLocationWithCoordinates:location.coordinate 
																						   startPoint:self.placeMarkTo.startPoint];
		newPlaceMark = self.placeMarkTo;
	}
	
	[self onShowRoute];
	
	//let's start search here to find the city and so on
	if (newPlaceMark) {
		[self setRequestedCurrentLocation:YES];
		[self startPlacemarkSearch:newPlaceMark];
	}
}

-(void)updateSelfLocationSearch{
	BOOL selfLocationSearchEnabled = ((self.placeMarkFrom && self.placeMarkFrom.selfLocation) || (self.placeMarkTo && self.placeMarkTo.selfLocation));
	[self.delegate setSelfLocationSearchEnabled:selfLocationSearchEnabled];
}

#pragma mark - UITextFieldDelegate methods

-(void)textFieldDidBeginEditing:(UITextField *)textField{
	if (textField == fromField) {
		if ([self.placeMarkFrom selfLocation]) {
			[textField setText:@""];
			self.placeMarkFrom = nil;
		}
	} else if (textField == toField) {
		if ([self.placeMarkTo selfLocation]) {
			[textField setText:@""];
			self.placeMarkTo = nil;
		}
	}
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.daysField) return;
    
	GoogleResultPlacemark *placeMark = textField == self.fromField ? placeMarkFrom : placeMarkTo;
	
	if (placeMark && [[placeMark name] isEqualToString:[textField text]]) {
		return;
	}
	
	self.requestedCurrentLocation = NO;
    self.currentTextField = textField;
	[self startAddressSearch:[textField text]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
    return YES;
}

#pragma mark AddressViewControllerDelegate

-(void)onAddressSelected:(id)address{
	Address *addr = (Address *)address;
	GoogleResultPlacemark *placeMark = [addr googleResultPlacemark];
	if (self.currentTextField == fromField) {
		[fromField setText:[addr addressName]];
		self.placeMarkFrom = placeMark;

	} else {
		[toField setText:[addr addressName]];
		self.placeMarkTo = placeMark;
	}
	if ([placeMark coordinatesInitialized]) {
		self.currentTextField = nil;
		[self onShowRoute];
	} else {
		self.currentFieldName = addr.addressName;
		[self startAddressSearch:[addr address]];
	}
	
}

-(void)onPlaceMarksSelected:(NSArray *)placeMarks{
	if ([placeMarks count] == 0)
		return;
	
	if ([placeMarks count] == 1) {
		GoogleResultPlacemark *placeMark = (GoogleResultPlacemark *)[placeMarks objectAtIndex:0];
		[currentTextField setText:[placeMark name]];
		if (self.currentTextField == fromField)
			self.placeMarkFrom = placeMark;
		else
			self.placeMarkTo = placeMark;
	} else {
		self.placeMarkFrom = (GoogleResultPlacemark *)[placeMarks objectAtIndex:0];
		[fromField setText:[self.placeMarkFrom name]];

		self.placeMarkTo = (GoogleResultPlacemark *)[placeMarks objectAtIndex:1];
		[toField setText:[self.placeMarkTo name]];
	}
	[self onShowRoute];
}

#pragma mark Events

-(IBAction)onChangeCar:(id)sender{
	[self resignEditFields];
	if ([parentController respondsToSelector:@selector(chooseCarType:)]) {
		[parentController performSelector:@selector(chooseCarType:) withObject:sender];
	}
	
}

-(IBAction)onChangeDate:(id)sender{
	[self resignEditFields];
	if ([parentController respondsToSelector:@selector(chooseDateTime:)]) {
		[parentController performSelector:@selector(chooseDateTime:) withObject:sender];
	}
}

-(IBAction)onGetFromAddressBook:(id)sender{
	/*if (![self checkIfAuthenticated]) {
		return;
	}*/
	[self loadAddressList:sender];
}

- (void) loadAddressList:(id)sender
{
	self.currentTextField = (sender == fromAddressButton ? fromField : toField);
	AddressViewController *newVc = [[AddressViewController alloc] init];
	[newVc setAllowsOnMapSelection:YES];//(sender == fromAddressButton)];
	[newVc setSelectionDelegate:self];
	[[self.parentController navigationController] pushViewController:newVc animated:YES];
}

- (BOOL) checkIfAuthenticated
{
	if ([prefManager.prefs.userGuid isEqualToString:@""]) {
		RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
		registerViewController.delegate = self;
		registerViewController.selectorOnDone = @selector(loadAddressList:);
		[[self.parentController navigationController] pushViewController:registerViewController animated:YES];
		[registerViewController release];
		return NO;
	}
	return YES;
}

-(IBAction)onReverseDirection:(id)sender{
	[self resignEditFields];
	
	GoogleResultPlacemark *tmpPlaceMark = placeMarkFrom;
	self.placeMarkFrom = placeMarkTo;
	self.placeMarkTo = tmpPlaceMark;
	[placeMarkFrom setStartPoint:YES];
	[placeMarkTo setStartPoint:NO];
	
	NSString *tmpText = [[fromField text] retain];
	[fromField setText:[toField text]];
	[toField setText:tmpText];
	[tmpText release];
	[self onShowRoute];
}

#pragma mark GoogleServiceManagerDelegate

-(void)onRequestFail{
    [super onRequestFail];
    self.currentFieldName = nil;
    self.currentTextField = nil;
}

@end
