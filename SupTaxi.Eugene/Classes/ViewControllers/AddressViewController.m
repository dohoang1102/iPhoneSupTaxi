//
//  AddressViewController.m
//  SupTaxi
//
//  Created by DarkAn on 9/4/11. //Modified my Eugene Zavalko on 06.09.11
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "AddressViewController.h"
#import "Address.h"
#import "BarButtonItemGreenColor.h"
#import "AddAddressViewController.h"

#import "ServerResponce.h"
#import "AppProgress.h"
#import "SupTaxiAppDelegate.h"
#import "RegisterViewController.h"


#define DEFAULT_ROWS_COUNT 3

@interface AddressViewController(Private)

- (void) GetAddressesThreadMethod:(id)obj;
- (void) GetAddressesResult:(id)obj;
- (void) showAlertMessage:(NSString *)alertMessage;
- (void) reloadTable;
- (NSMutableArray*) getAddressesByType: (NSInteger)type;
- (void)loadAddresses;
- (BOOL) checkIfAuthenticated;

@end

@implementation AddressViewController

@synthesize addressTable;
@synthesize searchBar;
@synthesize addressType;
@synthesize selectionDelegate;
@synthesize _addressListResponse;
@synthesize needReloadData;
@synthesize addAddressButton;

- (void) GetAddressesThreadMethod:(id)obj
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	AppProgress * progress = [AppProgress GetDefaultAppProgress];
	[progress StartProcessing:@"Загрузка адресной книги"];
	
	
	ServerResponce * responce = [[ServerResponce alloc] init];
	if (responce) 
	{		
		if ([responce GetAddressListRequest:[NSString stringWithFormat:@"%@",obj]])
		{
			NSArray * resultData = [responce GetDataItems];
			if (resultData) {
				self._addressListResponse = [resultData objectAtIndex:0]; 
			}
			
			[self performSelectorOnMainThread:@selector(GetAddressesResult:) 
								   withObject:nil 
								waitUntilDone:NO];
		}
		[responce release];
	}
	
	
	[progress StopProcessing:@"Готово" andHideTime:0.5];
	
	[pool release];
}

- (void) GetAddressesResult:(id)obj
{
	if (!_addressListResponse){
		[self showAlertMessage:@"Ошибка подключения, попытайтесь зайти в мои адреса через мгновение!"];
		return;
	}
	[self reloadTable];
}

-(BOOL)searchActive{
	return [searchBar text] && ![[searchBar text] isEqualToString:@""];
}

-(BOOL)showsCategories{
	return ![self searchActive] && self.addressType == my_addresses;
}

- (NSMutableArray*) getAddressesByType: (NSInteger)type{
	NSMutableArray * returnArray = [[NSMutableArray alloc] init];
	if (_addressListResponse == nil) {
		return [NSArray array];
	}
	for (Address * addr in _addressListResponse._addressList) {
		if (addr.addressType == type)
			[returnArray addObject:addr];
	}
	
	return [returnArray autorelease];
}
			 
-(NSArray *)addresses{
	
	NSArray *allAddresses;
	switch (self.addressType) {
		case my_addresses:
			allAddresses = [self getAddressesByType:0];  //[NSArray array];
			break;
		case train_stations:
			allAddresses = [self getAddressesByType:1];
			break;
		case airoports:
			allAddresses = [self getAddressesByType:2];
			break;
		default:
			break;
	}
	
	if (![self searchActive])
		return allAddresses;
	
	//Filter addresses by searched string
	NSMutableArray *retVal = [NSMutableArray array];
	
	NSString *searchedStr = [[searchBar text] lowercaseString];
	for (Address *address in allAddresses) {
		if ([[[address address] lowercaseString] rangeOfString:searchedStr].location != NSNotFound) {
			[retVal addObject:address];
		} else if ([[[address addressName] lowercaseString] rangeOfString:searchedStr].location != NSNotFound)
			[retVal addObject:address];
	}
	
	return retVal;
}

-(void)setSelectionDelegate:(id<AddressViewControllerDelegate>)newSelectionDelegate{
	selectionDelegate = newSelectionDelegate;
	if (selectionDelegate)
		self.navigationItem.rightBarButtonItem = nil;
	else
		self.navigationItem.rightBarButtonItem = self.addAddressButton;
}

#pragma mark Init/Dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		addressType = my_addresses;
    }
    return self;
}

- (void)dealloc
{
	[addAddressButton release];
	[addressTable release];
	[searchBar release];
	[_addressListResponse release];
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
	UIColor *color = [UIColor colorWithRed:16.0/255.0 green:79.0/255.0 blue:13.0/255.0 alpha:1];
	
	if (self.addressType == my_addresses) {
		self.addAddressButton = [UIBarButtonItem barButtonItemWithTint:color andTitle:@"Добавить" andTarget:self andSelector:@selector(onAddAddress:)];
		if (!selectionDelegate)
			self.navigationItem.rightBarButtonItem = self.addAddressButton;
	} 
	if (self.addressType != my_addresses || self.selectionDelegate != nil) {
		UIBarButtonItem *backButton = [UIBarButtonItem barButtonItemWithTint:color andTitle:@"Назад" andTarget:self andSelector:@selector(onBack:)];
		self.navigationItem.leftBarButtonItem = backButton;
	}
    
	UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_header.png"]];
    img.backgroundColor = [UIColor clearColor];
	self.navigationItem.titleView = img;
	[img release];
}

-(void)reloadTable{
	if (self.needReloadData) {
		[self loadAddresses];
		[self setNeedReloadData:NO];
	}else {
		[addressTable reloadData];
	}
}

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	
	if (!selectionDelegate) {
		if ([prefManager.prefs.userGuid isEqualToString:@""]) {
            [self showAlertMessage:@"Для возможности просмотра списка Ваших адресов, Вам необходимо либо авторизоватся, либо зарегистрироватся через секцию Настройки!"];
        }
	}
	[self loadAddresses];
	//Deselect the row after returning to this view and reloading table
	[[self addressTable] selectRowAtIndexPath:nil animated:YES scrollPosition:UITableViewScrollPositionNone];
	[self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.5];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	prefManager = [SupTaxiAppDelegate sharedAppDelegate].prefManager;
	
	[self initPreferences];
	/*if (!selectionDelegate) {
		[self checkIfAuthenticated];
	}*/
	[self loadAddresses];
	
}

- (BOOL) checkIfAuthenticated
{
	//Check if user authenticated
	if ([prefManager.prefs.userGuid isEqualToString:@""]) {
		RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
		registerViewController.delegate = self;
		registerViewController.selectorOnDone = @selector(loadAddresses); 
		[self.navigationController pushViewController:registerViewController animated:YES];
		[registerViewController release];
		return NO;
	}
	return YES;
}


- (void)loadAddresses
{	
	[NSThread detachNewThreadSelector:@selector(GetAddressesThreadMethod:)
							 toTarget:self 
						   withObject:[NSString stringWithString:prefManager.prefs.userGuid]];
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

-(Address *)addressByIndexPath:(NSIndexPath *)indexPath{
	int addressIndex = self.addressType == my_addresses ? indexPath.row-DEFAULT_ROWS_COUNT : indexPath.row;
	return [[self addresses] objectAtIndex:addressIndex];
}

-(void)editAddress:(Address *)address{
	if (selectionDelegate) {
		[[self navigationController] popViewControllerAnimated:![selectionDelegate isKindOfClass:[AddressViewController class]]];
		[selectionDelegate onAddressSelected:address];
	}else if (self.addressType == my_addresses) {
		AddAddressViewController *newController = [[AddAddressViewController alloc] init];
		[newController setDelegate:self];
		[newController setAddress:address];
		[[self navigationController] pushViewController:newController animated:YES];
		[newController release];
	} else
		[[self addressTable] selectRowAtIndexPath:nil animated:YES scrollPosition:UITableViewScrollPositionNone];
}

-(void)showNewControllerWithAddressType:(enum AddressType)anAddressType{
	AddressViewController *newController = [[AddressViewController alloc] init];
	if ([self selectionDelegate])
		[newController setSelectionDelegate:self];
	[newController setAddressType:anAddressType];
	[self.navigationController pushViewController:newController animated:YES];
	[newController release];
}

#pragma mark TableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (![self showsCategories])
		return 44;
	switch (indexPath.row) {
		case 0:
		case 1:
		case 2:
			return 50;
			
		default:
			return 44;
	}
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if (![self showsCategories]) {
		Address *addr = [[self addresses] objectAtIndex:indexPath.row];
		[self editAddress:addr];
		return;
	}
	
	switch (indexPath.row) {
		case 0:
			//show airoports
			[self showNewControllerWithAddressType:airoports];			
			break;
		case 1:
			//show trainstations
			[self showNewControllerWithAddressType:train_stations];
		case 2:
			//do nothing
			[[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
			break;
		default: {
			if (selectionDelegate) {
				[selectionDelegate onAddressSelected:[self addressByIndexPath:indexPath]];
				[[self navigationController] popViewControllerAnimated:YES];
			}else
				[self editAddress:[self addressByIndexPath:indexPath]];
			break;
		}
	}
}

#pragma mark TableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if ([self showsCategories])
		return DEFAULT_ROWS_COUNT + [[self addresses] count];	//without any address
	else
		return [[self addresses] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSString *cellIdentifier = @"cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
	}
	
	UIImage *cellIcon = nil;	//need to set this icon below to have it in cell
	NSString *cellTitle = @"";
	NSString *cellDetails = @"";
	UITableViewCellAccessoryType accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	if (indexPath.row >= DEFAULT_ROWS_COUNT || ![self showsCategories]) {
		Address *address = [self addressByIndexPath:indexPath];
        
        NSLog(@"Address: %@", address.address);
        NSLog(@"Address Name: %@", address.addressName);
        
		cellTitle = [address addressName];
		cellDetails = [address address];
		accessoryType = UITableViewCellAccessoryNone;
	} else if (indexPath.row == 0) {
		cellTitle = @"Аэропорты";
	} else if (indexPath.row == 1) {
		cellTitle = @"Ж/д вокзалы";
	} else if (indexPath.row == 2) {
		cellTitle = @"Мои Адреса";
		accessoryType = UITableViewCellAccessoryNone;
	} 
    
	[[cell imageView] setImage:cellIcon];
	[[cell textLabel] setText:cellTitle];
	[[cell detailTextLabel] setText:cellDetails];
	[cell setAccessoryType:accessoryType];
	
	return cell;
}

#pragma mark UISearchBarDelegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar{
	[theSearchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)theSearchBar{
	[theSearchBar setShowsCancelButton:NO animated:YES];
}

-(void)searchBar:(UISearchBar *)aSearchBar textDidChange:(NSString *)searchText{
	[addressTable reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar{
	[theSearchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)theSearchBar{
	[theSearchBar setText:@""];
	[theSearchBar resignFirstResponder];
}

#pragma mark AddressViewControllerDelegate

-(void)onAddressSelected:(id)address{
	if (self.selectionDelegate) {
		[self.selectionDelegate onAddressSelected:address];
		[self.navigationController popViewControllerAnimated:YES];
	}
}

#pragma mark Events

-(void)onAddAddress:(id)sender{
	[self editAddress:nil];	
}

-(void)onBack:(id)sender{
	[[self navigationController] popViewControllerAnimated:YES];
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
