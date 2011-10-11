    //
//  HistoryDetailViewController.m
//  SupTaxi
//
//  Created by Eugene Zavalko on 07.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "HistoryDetailViewController.h"
#import "BarButtonItemGreenColor.h"
#import	"Constants.h"
#import "Address.h"
#import "AddAddressViewController.h"

@interface HistoryDetailViewController(Private)

-(void)onBack:(id)sender;
-(void)addAddress:(Address *)address;

@end

@implementation HistoryDetailViewController

@synthesize lblTime;
@synthesize lblFrom;
@synthesize lblTo;
@synthesize lblStatus;
@synthesize lblComment;
@synthesize lblCarrier;

@synthesize lblSchedule;
@synthesize lblCType;

-(void)initProperties{
	UIColor *color = [UIColor colorWithRed:16.0/255.0 green:79.0/255.0 blue:13.0/255.0 alpha:1];
	
	UIBarButtonItem *backButton = [UIBarButtonItem barButtonItemWithTint:color andTitle:@"Назад" andTarget:self andSelector:@selector(onBack:)];
	self.navigationItem.leftBarButtonItem = backButton;
    
	UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_header.png"]];
    img.backgroundColor = [UIColor clearColor];
	self.navigationItem.titleView = img;
	[img release];
}

-(void)onBack:(id)sender{
	[[self navigationController] popViewControllerAnimated:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self initProperties];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:YES];
	[self.lblTime setText:orderToView.dateTime];
	[self.lblFrom setText:orderToView.from];
	[self.lblTo setText:orderToView.to];
	[self.lblStatus setText:[Constants historyStatusById:orderToView.status]];
	[self.lblComment setText:orderToView.comment];
    [self.lblCarrier setText:orderToView.carrier];
    [self.lblCType setText:[Constants getCarTypeString: [NSString stringWithFormat:@"%d", orderToView.vType]]];
    [self.lblSchedule setText:orderToView.schedule];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)btnAddFrom:(id)sender
{
    Address * addr = [self getAddress:orderToView.from area:orderToView.fromArea lat:orderToView.fromLon lon:orderToView.fromLat];
    [self addAddress:addr];
}

- (IBAction)btnAddTo:(id)sender
{
    Address * addr = [self getAddress:orderToView.to area:orderToView.toArea lat:orderToView.toLon lon:orderToView.toLat];
    [self addAddress:addr];
}

- (Address*) getAddress:(NSString*)address area:(NSString*)area lat:(double)lat lon:(double)lon
{
    Address * addr = [[Address alloc] initWithId:0 
                                             name:@"" 
                                          address:address 
                                      addressArea:area 
                                             type:0
                                              lon:lon 
                                              lat:lat];
    return [addr autorelease];
}

-(void)addAddress:(Address *)address{
    AddAddressViewController *newController = [[AddAddressViewController alloc] init];
    [newController setAddress:address];
	[[self navigationController] pushViewController:newController animated:YES];
	[newController release];
}

- (void)dealloc {
	[lblTime release];
	[lblFrom release];
	[lblTo release];
	[lblStatus release];
	[lblComment release];
    [lblCarrier release];
	
    [lblSchedule release];
    [lblCType release];
    
	[orderToView release];
    [super dealloc];
}

- (void) SetOrder:(Order*)order
{
	orderToView = order;
}

@end
