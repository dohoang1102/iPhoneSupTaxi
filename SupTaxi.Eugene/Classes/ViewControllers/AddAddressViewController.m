//
//  AddAddressViewController.m
//  SupTaxi
//
//  Created by DarkAn on 9/4/11. //Modified my Eugene Zavalko on 06.09.11
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "AddAddressViewController.h"
#import "BarButtonItemGreenColor.h"

#import "ServerResponce.h"
#import "AppProgress.h"
#import "SupTaxiAppDelegate.h"

@interface AddAddressViewController ()

-(void)onBack:(id)sender;

@end

@interface AddAddressViewController(Private)

- (void) AddAddressesThreadMethod:(id)obj;
- (void) AddAddressesResult:(id)obj;

- (void) DelAddressesThreadMethod:(id)obj;
- (void) DelAddressesResult:(id)obj;

- (void) UpdAddressesThreadMethod:(id)obj;
- (void) UpdAddressesResult:(id)obj;

- (void) showAlertMessage:(NSString *)alertMessage;

@end

@implementation AddAddressViewController

#define USER_GUID_KEY @"uGUID"
#define ANAME_KEY @"ANAME_KEY"
#define ADDR_KEY @"ADDR_KEY"
#define LAT_KEY @"LAT_KEY"
#define LON_KEY @"LON_KEY"

#define AID_KEY @"AID_KEY"

#pragma mark Properties

@synthesize mapController;
@synthesize addressSearchBar;
@synthesize delegate;
@synthesize address;
@synthesize _addressResponse;

- (void) AddAddressesThreadMethod:(id)obj
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	AppProgress * progress = [AppProgress GetDefaultAppProgress];
	[progress StartProcessing:@"Добавление адреса"];
	
	
	ServerResponce * responce = [[ServerResponce alloc] init];
	if (responce) 
	{
		NSDictionary * d = (NSDictionary*)obj;
		NSString * guid = [d objectForKey:USER_GUID_KEY];
		NSString * name = [d objectForKey:ANAME_KEY];
		NSString * addr = [d objectForKey:ADDR_KEY];
		double lat = [[d objectForKey:LAT_KEY] doubleValue];
		double lon = [[d objectForKey:LON_KEY] doubleValue];
		
		if ([responce AddAddressRequest:guid 
								   name:name 
								address:addr 
									lat:lat 
									lon:lon])
		{
			NSArray * resultData = [responce GetDataItems];
			if (resultData) {
				self._addressResponse = [resultData objectAtIndex:0]; 
			}
			
			[self performSelectorOnMainThread:@selector(AddAddressesResult:) 
								   withObject:nil 
								waitUntilDone:NO];
		}
		[responce release];
	}
	
	
	[progress StopProcessing:@"Готово" andHideTime:0.5];
	
	[pool release];
}

- (void) AddAddressesResult:(id)obj
{
	if (!_addressResponse || _addressResponse._result == NO)
		[self showAlertMessage:@"Ошибка добавления адреса, попробуйте, пожалуйста, еще раз!"];
	if (_addressResponse._result == YES) {
		[delegate setNeedReloadData:YES];
		[self onBack:nil];
	}
}

- (void) DelAddressesThreadMethod:(id)obj
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	AppProgress * progress = [AppProgress GetDefaultAppProgress];
	[progress StartProcessing:@"Удаление адреса"];
	
	
	ServerResponce * responce = [[ServerResponce alloc] init];
	if (responce) 
	{
		NSDictionary * d = (NSDictionary*)obj;
		NSString * guid = [d objectForKey:USER_GUID_KEY];
		NSInteger addrId = [[d objectForKey:AID_KEY] intValue];
		
		if ([responce DelAddressRequest:guid addressId:addrId])
		{
			NSArray * resultData = [responce GetDataItems];
			if (resultData) {
				self._addressResponse = [resultData objectAtIndex:0]; 
			}
			
			[self performSelectorOnMainThread:@selector(DelAddressesResult:) 
								   withObject:nil 
								waitUntilDone:NO];
		}
		[responce release];
	}
	
	
	[progress StopProcessing:@"Готово" andHideTime:0.5];
	
	[pool release];
}

- (void) DelAddressesResult:(id)obj
{
	if (!_addressResponse || _addressResponse._result == NO)
		[self showAlertMessage:@"Не удалось удалить адрес, попробуйте, пожалуйста, еще раз!"];
	if (_addressResponse._result == YES) {
		[delegate setNeedReloadData:YES];
		[self onBack:nil];
	}
}

- (void) UpdAddressesThreadMethod:(id)obj
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	AppProgress * progress = [AppProgress GetDefaultAppProgress];
	[progress StartProcessing:@"Обновление адреса"];
	
	
	ServerResponce * responce = [[ServerResponce alloc] init];
	if (responce) 
	{
		NSDictionary * d = (NSDictionary*)obj;
		NSString * guid = [d objectForKey:USER_GUID_KEY];
		NSInteger addressId = [[d objectForKey:AID_KEY] intValue];
		NSString * name = [d objectForKey:ANAME_KEY];
		NSString * addr = [d objectForKey:ADDR_KEY];
		double lat = [[d objectForKey:LAT_KEY] doubleValue];
		double lon = [[d objectForKey:LON_KEY] doubleValue];
		
		if ([responce UpdAddressRequest:guid 
							  addressId:addressId
								   name:name 
								address:addr 
									lat:lat 
									lon:lon])
		{
			NSArray * resultData = [responce GetDataItems];
			if (resultData) {
				self._addressResponse = [resultData objectAtIndex:0]; 
			}
			
			[self performSelectorOnMainThread:@selector(UpdAddressesResult:) 
								   withObject:nil 
								waitUntilDone:NO];
		}
		[responce release];
	}
	
	
	[progress StopProcessing:@"Готово" andHideTime:0.5];
	
	[pool release];
}

- (void) UpdAddressesResult:(id)obj
{
	if (!_addressResponse || _addressResponse._result == NO)
		[self showAlertMessage:@"Ошибка обновления адреса, попробуйте, пожалуйста, еще раз!"];
	if (_addressResponse._result == YES) {
		[delegate setNeedReloadData:YES];
		[self onBack:nil];
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
	[addressSearchBar setDelegate:nil];
	[address release];
	
	[mapController release];
	[addressSearchBar release];
	
	[_addressResponse release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)initProperties{
	UIColor *color = [UIColor colorWithRed:16.0/255.0 green:79.0/255.0 blue:13.0/255.0 alpha:1];
	
	
	UIBarButtonItem *orderButton = [UIBarButtonItem barButtonItemWithTint:color andTitle:@"Готово" andTarget:self andSelector:@selector(onAddAddress:)];
	self.navigationItem.rightBarButtonItem = orderButton;

	UIBarButtonItem *backButton = [UIBarButtonItem barButtonItemWithTint:color andTitle:@"Назад" andTarget:self andSelector:@selector(onBack:)];
	self.navigationItem.leftBarButtonItem = backButton;
    
	UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_header.png"]];
	self.navigationItem.titleView = img;
	[img release];
	
	//Creating and adding MapViewController
	MapViewController *newMapViewController = [[MapViewController alloc] init];
	[[newMapViewController view] setFrame:[[self view] frame]];
	[[self view] addSubview:[newMapViewController view]];
	self.mapController = newMapViewController;
	[newMapViewController release];
	
	MapViewAddressSearchBar *searchBar = [[MapViewAddressSearchBar alloc] init];
	[newMapViewController setMapViewSearchBar:searchBar];
	self.addressSearchBar = searchBar;
	[searchBar release];
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];

	prefManager = [SupTaxiAppDelegate sharedAppDelegate].prefManager;
	
	if (self.address) {
		[[[self addressSearchBar] nameField] setText:[self.address addressName]];
		[[[self addressSearchBar] addressField] setText:[[self address] address]];
		
		if ([self.address.latitude doubleValue] == 0 || [self.address.longitude doubleValue] == 0) {
			[[self addressSearchBar] startAddressSearch:[[self address] address]];
		}else {
			[[self addressSearchBar] setPlaceMark:[[self address] googleResultPlacemark]];
		}
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	prefManager = [SupTaxiAppDelegate sharedAppDelegate].prefManager;
	
	[self initProperties];
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

-(void)addAddress{
	Address *addr;
	if (self.address) {
		addr = self.address;
	} else {
		//Should Add Address here
		NSMutableDictionary * d = [NSMutableDictionary dictionaryWithCapacity:5];
		[d setValue:prefManager.prefs.userGuid forKey:USER_GUID_KEY];
		[d setValue:[[self addressSearchBar] nameField] forKey:ANAME_KEY];
		[d setValue:[[self addressSearchBar] addressField] forKey:ADDR_KEY];		
		[d setValue:[NSString stringWithFormat:@"%f", self.addressSearchBar.placeMark.coordinate.latitude] forKey:LAT_KEY];
		[d setValue:[NSString stringWithFormat:@"%f", self.addressSearchBar.placeMark.coordinate.longitude] forKey:LON_KEY];
		
		[NSThread detachNewThreadSelector:@selector(AddAddressesThreadMethod:)
								 toTarget:self 
							   withObject:d];
		return;
	}
	//address edited
	
	//self.addressSearchBar.placeMark
	[addr initWithGoogleResultPlacemark:[self.addressSearchBar placeMark]];
	[addr setAddressName:[[self.addressSearchBar nameField] text]];
	//update address
	NSMutableDictionary * d = [NSMutableDictionary dictionaryWithCapacity:6];
	[d setValue:prefManager.prefs.userGuid forKey:USER_GUID_KEY];
	[d setValue:[NSString stringWithFormat:@"%i", addr.addressId] forKey:AID_KEY];
	[d setValue:addr.addressName forKey:ANAME_KEY];
	[d setValue:addr.address forKey:ADDR_KEY];		
	[d setValue:[NSString stringWithFormat:@"%f", [addr.latitude doubleValue]] forKey:LAT_KEY];
	[d setValue:[NSString stringWithFormat:@"%f", [addr.longitude doubleValue]] forKey:LON_KEY];
	
	[NSThread detachNewThreadSelector:@selector(UpdAddressesThreadMethod:)
							 toTarget:self 
						   withObject:d];
	
}

-(void)deleteAddress{
	NSMutableDictionary * d = [NSMutableDictionary dictionaryWithCapacity:5];
	[d setValue:prefManager.prefs.userGuid forKey:USER_GUID_KEY];	
	[d setValue:[NSString stringWithFormat:@"%i", self.address.addressId] forKey:AID_KEY];
	
	[NSThread detachNewThreadSelector:@selector(DelAddressesThreadMethod:)
							 toTarget:self 
						   withObject:d];
}

#pragma mark UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	switch (buttonIndex) {
		case 0:
			[self deleteAddress];
			break;
		case 1:
			[self addAddress];
			break;
		case 2:
			
			break;
		default:
			break;
	}
}

#pragma mark Events

-(void)onBack:(id)sender{
	[[self navigationController] popViewControllerAnimated:YES];
}

-(void)onAddAddress:(id)sender{
	if (![self.addressSearchBar validate])
		return;
	
	if (self.address) {
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" 
																 delegate:self 
														cancelButtonTitle:@"сохранить" 
												   destructiveButtonTitle:@"удалить" 
														otherButtonTitles:nil];
		[actionSheet addButtonWithTitle:@"Отмена"];
		[actionSheet showFromTabBar:[[self tabBarController] tabBar]];
		[actionSheet release];
	} else
		[self addAddress];

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
