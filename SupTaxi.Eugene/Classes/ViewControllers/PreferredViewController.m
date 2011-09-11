//
//  PreferredViewController.m
//  SupTaxi
//
//  Created by Eugene Zavalko on 09.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "PreferredViewController.h"
#import "PreferredCell.h"
#import "BarButtonItemGreenColor.h"

#import "ServerResponce.h"
#import "AppProgress.h"
#import "SupTaxiAppDelegate.h"

#define USER_GUID_KEY @"uGUID"
#define PCID_KEY @"PCID_KEY"

@interface PreferredViewController(Private)

- (void) LoadPreferredCarriersThreadMethod:(id)obj;
- (void) LoadPreferredCarriersResult:(id)obj;

- (void) AddPreferredCarriersThreadMethod:(id)obj;
- (void) AddPreferredCarriersResult:(id)obj;

- (void) DelPreferredCarriersThreadMethod:(id)obj;
- (void) DelPreferredCarriersResult:(id)obj;

- (IBAction)backAction:(id)sender;

- (void) showAlertMessage:(NSString *)alertMessage;

@end

@implementation PreferredViewController

@synthesize _preferredResponse;
@synthesize _response;

- (void) LoadPreferredCarriersThreadMethod:(id)obj
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	AppProgress * progress = [AppProgress GetDefaultAppProgress];
	[progress StartProcessing:@"Загрузка перевозщиков"];
	
	
	ServerResponce * responce = [[ServerResponce alloc] init];
	if (responce) 
	{		
		if ([responce GetPrefferedListRequest:[NSString stringWithFormat:@"%@",obj]])
		{
			NSArray * resultData = [responce GetDataItems];
			if (resultData) {
				self._preferredResponse = [resultData objectAtIndex:0]; 
			}
			
			[self performSelectorOnMainThread:@selector(LoadPreferredCarriersResult:) 
								   withObject:nil 
								waitUntilDone:NO];
		}
		[responce release];
	}
	
	
	[progress StopProcessing:@"Готово" andHideTime:0.5];
	
	[pool release];
}

- (void) LoadPreferredCarriersResult:(id)obj
{
	if (!_preferredResponse){
		[self showAlertMessage:@"Ошибка подключения, попытайтесь немного позже!"];
		return;
	}
	[self.tableView reloadData];
}

- (void) AddPreferredCarriersThreadMethod:(id)obj
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	AppProgress * progress = [AppProgress GetDefaultAppProgress];
	[progress StartProcessing:@"Добавляем перевозщика"];
	
	
	ServerResponce * responce = [[ServerResponce alloc] init];
	if (responce) 
	{
		NSDictionary * d = (NSDictionary*)obj;
		NSString * guid = [d objectForKey:USER_GUID_KEY];
		NSInteger cId = [[d objectForKey:PCID_KEY] intValue];
		
		if ([responce AddPreferredCarrierRequest:guid 
									   carrierId:cId])
		{
			NSArray * resultData = [responce GetDataItems];
			if (resultData) {
				self._response = [resultData objectAtIndex:0]; 
			}
			
			[self performSelectorOnMainThread:@selector(AddPreferredCarriersResult:) 
								   withObject:nil 
								waitUntilDone:NO];
		}
		[responce release];
	}
	
	
	[progress StopProcessing:@"Готово" andHideTime:0.5];
	
	[pool release];
}

- (void) AddPreferredCarriersResult:(id)obj
{
	if (!_response || _response._result == NO)
		[self showAlertMessage:@"Ошибка добавления адреса, попробуйте, пожалуйста, еще раз!"];
	if (_response._result == YES) {
		//[delegate setNeedReloadData:YES];
		//[self onBack:nil];
	}
}

- (void) DelPreferredCarriersThreadMethod:(id)obj
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	AppProgress * progress = [AppProgress GetDefaultAppProgress];
	[progress StartProcessing:@"Удаляем перевозщика"];
	
	
	ServerResponce * responce = [[ServerResponce alloc] init];
	if (responce) 
	{
		NSDictionary * d = (NSDictionary*)obj;
		NSString * guid = [d objectForKey:USER_GUID_KEY];
		NSInteger cId = [[d objectForKey:PCID_KEY] intValue];
		
		if ([responce DelPreferredCarrierRequest:guid 
									   carrierId:cId])
		{
			NSArray * resultData = [responce GetDataItems];
			if (resultData) {
				self._response = [resultData objectAtIndex:0]; 
			}
			
			[self performSelectorOnMainThread:@selector(DelPreferredCarriersResult:) 
								   withObject:nil 
								waitUntilDone:NO];
		}
		[responce release];
	}
	
	
	[progress StopProcessing:@"Готово" andHideTime:0.5];
	
	[pool release];
}

- (void) DelPreferredCarriersResult:(id)obj
{
	if (!_response || _response._result == NO)
		[self showAlertMessage:@"Не удалось удалить адрес, попробуйте, пожалуйста, еще раз!"];
	if (_response._result == YES) {
		//[delegate setNeedReloadData:YES];
		//[self onBack:nil];
	}
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	prefManager = [SupTaxiAppDelegate sharedAppDelegate].prefManager;
    
	self.tableView.allowsSelection = NO;
	
	UIColor *buttonColor = [UIColor colorWithRed:2.0/255.0 green:12.0/255.0 blue:2.0/255.0 alpha:1];
    UIBarButtonItem *backButton = [UIBarButtonItem barButtonItemWithTint:buttonColor andTitle:@"Закрыть" andTarget:self andSelector:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1];
     
	UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_header.png"]];
	self.navigationItem.titleView = img;
	[img release];
	
    [self.navigationItem setHidesBackButton:YES];
	
	[NSThread detachNewThreadSelector:@selector(LoadPreferredCarriersThreadMethod:)
							 toTarget:self 
						   withObject:prefManager.prefs.userGuid];
}

- (IBAction)backAction:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_preferredResponse._carriers count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PreferredCell *cell = (PreferredCell *)[tableView dequeueReusableCellWithIdentifier:@"CellId"];
	if (cell == nil) {
		cell = [[[PreferredCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"CellId"] autorelease];        
	}
    
	Carrier *carrier = [_preferredResponse._carriers objectAtIndex:indexPath.row];
    
    cell.carrierLogo.image = carrier.carrierLogo;
	[cell.switcher setOn:carrier.isPreferred];
	[cell.switcher setTag:carrier.carrierId];
    [cell.switcher addTarget:self action:@selector(changeSelection:) forControlEvents:UIControlEventValueChanged];
    return cell;
}

- (IBAction)changeSelection:(id)sender
{
	UICustomSwitch  *senderSwitch = (UICustomSwitch *)sender;
	BOOL result = [senderSwitch isOn];
	int carrierId = senderSwitch.tag;
	NSLog(@"Sender Switch : %d Id: %i", (int)result, carrierId);
		
	NSMutableDictionary * d = [NSMutableDictionary dictionaryWithCapacity:3];
	[d setValue:prefManager.prefs.userGuid forKey:USER_GUID_KEY];
	[d setValue:[NSString stringWithFormat:@"%i", carrierId] forKey:PCID_KEY];
	
	if (result) {
		[NSThread detachNewThreadSelector:@selector(AddPreferredCarriersThreadMethod:)
								 toTarget:self 
							   withObject:d];
	} else {
		[NSThread detachNewThreadSelector:@selector(DelPreferredCarriersThreadMethod:)
								 toTarget:self 
							   withObject:d];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	
	[_response release];
	[_preferredResponse release];
	
    [super dealloc];
}

- (void) showAlertMessage:(NSString *)alertMessage
{
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" 
													 message:alertMessage 
													delegate:nil 
										   cancelButtonTitle:@"OK" 
										   otherButtonTitles:nil];
	[alert show];
	[alert release];
}

@end

