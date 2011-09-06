//
//  MapViewAddressSearchBar.m
//  SupTaxi
//
//  Created by DarkAn on 9/4/11.
//  Copyright 2011 DNK. All rights reserved.
//

#import "MapViewAddressSearchBar.h"


@implementation MapViewAddressSearchBar

#pragma mark Properties

@synthesize nameField;
@synthesize addressField;

@synthesize placeMark;

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
	[nameField release];
	[addressField release];
	[placeMark release];
	
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark Helping Methods

-(void)resignEditFields{
	[addressField resignFirstResponder];
}

-(NSArray *)placeMarks{
	if (placeMark)
		return [NSArray arrayWithObject:placeMark];
	return [NSArray array];
}

-(void)setFoundPlaceMark:(GoogleResultPlacemark *)newPlaceMark{
	self.placeMark = newPlaceMark;
	[addressField setText:[self.placeMark name]];
}

-(BOOL)validate{
	NSString *message = nil;
	if (![[self.nameField text] isEqualToString:@""] && ![[self.addressField text] isEqualToString:@""]) {
		return YES;
	} else
		message = @"Пожалуйста заполните все поля";
	
	if (!message && [self placeMark]) {
		return YES;
	} else
		message = @"Адрес не может быть добавлен пока не определены координаты";
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
	
	return NO;
}

#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
	[self resignEditFields];
	
	[self startAddressSearch:[textField text]];
	
	return YES;
}

@end
