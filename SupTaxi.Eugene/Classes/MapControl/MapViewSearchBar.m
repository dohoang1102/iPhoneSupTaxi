//
//  MapViewSearchBar.m
//  TestMapView
//
//  Created by DarkAn on 9/3/11.
//  Copyright 2011 DNK. All rights reserved.
//

#import "MapViewSearchBar.h"

@implementation MapViewSearchBar

#pragma mark Properties

@synthesize delegate;

@synthesize placeFrom;
@synthesize placeTo;
@synthesize distanceLabel;

@synthesize placeMarkFrom;
@synthesize placeMarkTo;

@synthesize googleManager;

@synthesize hidden;

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
	[googleManager release];
	
	[placeFrom release];
	[placeTo release];
	[distanceLabel release];
	
	[placeMarkFrom release];
	[placeMarkTo release];
	
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

-(NSArray *)placeMarks{
	NSMutableArray *placemarks = [NSMutableArray array];
	if (self.placeMarkFrom)
		[placemarks addObject:self.placeMarkFrom];
	if (self.placeMarkTo)
		[placemarks addObject:self.placeMarkTo];
	return placemarks;
}

-(void)resignEditFields{
	[placeFrom resignFirstResponder];
	[placeTo resignFirstResponder];
}

-(void)setFoundPlaceMark:(GoogleResultPlacemark *)placeMark{
	if (searchingAddressFrom){
		[placeMark setStartPoint:YES];
		placeMarkFrom = placeMark;
		[placeFrom setText:[placeMark name]];
	} else {
		[placeMark setStartPoint:NO];
		placeMarkTo = placeMark;
		[placeTo setText:[placeMark name]];
	}
}

#pragma mark SearchBarDelegate

-(void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
	NSLog(@"Add address to bookmark");
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	if ([[searchBar text] isEqualToString:@""]) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter the address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		return;
	}
	[searchBar resignFirstResponder];
	
	searchingAddressFrom = (searchBar == self.placeFrom);
	
	[self startAddressSearch:[searchBar text]];
}



#pragma mark Events


@end
