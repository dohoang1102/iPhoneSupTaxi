    //
//  HistoryDetailViewController.m
//  SupTaxi
//
//  Created by Eugene Zavalko on 07.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "HistoryDetailViewController.h"
#import "BarButtonItemGreenColor.h"

@interface HistoryDetailViewController(Private)

-(void)onBack:(id)sender;

@end


@implementation HistoryDetailViewController

@synthesize lblTime;
@synthesize lblFrom;
@synthesize lblTo;
@synthesize lblStatus;
@synthesize lblComment;

-(void)initProperties{
	UIColor *color = [UIColor colorWithRed:16.0/255.0 green:79.0/255.0 blue:13.0/255.0 alpha:1];
	
	UIBarButtonItem *backButton = [UIBarButtonItem barButtonItemWithTint:color andTitle:@"Назад" andTarget:self andSelector:@selector(onBack:)];
	self.navigationItem.leftBarButtonItem = backButton;
    
	UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_header.png"]];
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
	[self.lblStatus setText:(orderToView.status)? @"Выполнен": @"В ожидании"];
	[self.lblComment setText:orderToView.comment];
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


- (void)dealloc {
	[lblTime release];
	[lblFrom release];
	[lblTo release];
	[lblStatus release];
	[lblComment release];
	
	[orderToView release];
    [super dealloc];
}

- (void) SetOrder:(Order*)order
{
	orderToView = order;
}

@end
