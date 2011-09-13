//
//  HistoryViewController.m
//  SupTaxi
//
//  Created by Eugene Zavalko on 04.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "HistoryViewController.h"
#import "ServerResponce.h"
#import "AppProgress.h"
#import "SupTaxiAppDelegate.h"
#import "BarButtonItemGreenColor.h"
#import "Order.h"
#import "HistoryDetailViewController.h"
#import "HistoryItemCell.h"
#import "RegisterViewController.h"
#import "Constants.h"
#import "AditionalPrecompileds.h"

#define ITEMS_PER_PAGE (10)

#define NEXT_PAGE_KEY @"next"
#define USER_GUID_KEY @"uGUID"

@interface HistoryViewController(Private)

- (void)loadHistory;
- (void) DowloadHistoryThreadMethod:(id)obj;
- (void) ReloadTableView:(id)obj;
- (BOOL) IsNextPageAvaiable;
//- (void) LoadNextPage;
- (BOOL) checkIfAuthenticated;
- (void) showAlertMessage:(NSString *)alertMessage;

@end

@implementation HistoryViewController

@synthesize _historyResponse;

- (void) DowloadHistoryThreadMethod:(id)obj
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	AppProgress * progress = [AppProgress GetDefaultAppProgress];
	[progress StartProcessing:@"Загрузка истории"];
	
	ServerResponce * responce = [[ServerResponce alloc] init];
	if (responce) 
	{
		NSDictionary * d = (NSDictionary*)obj;
		NSNumber * nextPage = [d objectForKey:NEXT_PAGE_KEY];
		NSString * guid = [d objectForKey:USER_GUID_KEY];
		if ([responce GetOrdersHistoryRequest:guid
								   pageNumber:[nextPage unsignedIntegerValue] 
								 numberOfRows:ITEMS_PER_PAGE]) 
		{
			
			_totalPagesCount = [responce GetNavigatePages];
			_pagesLoadedCount = [responce GetNavigatePage];
			_totalItemsCount = [responce GetNavigateCount];
			
			if (_hItems == nil) 
			{
				_hItems = [[NSMutableArray alloc] initWithCapacity:_totalItemsCount];
			}
			
			NSArray * resultData = [responce GetDataItems];
			if (resultData) {
				self._historyResponse = [resultData objectAtIndex:0]; 
                if (nextPage.intValue == 0) {
                    [_hItems removeAllObjects];
                }
                
				[_hItems addObjectsFromArray:self._historyResponse._orders]; 
			}
			
			NSLog(@"Count %d", [_historyResponse._orders count]);
			
			[self performSelectorOnMainThread:@selector(ReloadTableView:) 
								   withObject:nil 
								waitUntilDone:NO];
		}
		[responce release];
	}
	
	
	[progress StopProcessing:@"Готово" andHideTime:0.5];
	[pool release];
}

- (BOOL) IsNextPageAvaiable
{
	if (_totalItemsCount > 0) 
	{
		if (_hItems == nil) 
		{
			return YES;
		}
		return ([_hItems count] < _totalItemsCount);
	}
	return NO;
}

- (void) LoadNextPage
{
	const NSUInteger nextPageNumber = (_pagesLoadedCount + 1);
	
	NSMutableDictionary * d = [NSMutableDictionary dictionaryWithCapacity:2];
	[d setValue:[NSNumber numberWithUnsignedInteger:nextPageNumber] forKey:NEXT_PAGE_KEY];
	[d setValue:prefManager.prefs.userGuid forKey:USER_GUID_KEY];
	
	NSLog(@"\nPlotsTableViewController Dowload history objects page=%d", nextPageNumber);
	
	[NSThread detachNewThreadSelector:@selector(DowloadHistoryThreadMethod:)
							 toTarget:self 
						   withObject:d];
}

- (void)dealloc
{	[registerController release];
	[detailView release];
	[_historyResponse release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	//[self checkIfAuthenticated];
    
    if ([prefManager.prefs.userGuid isEqualToString:@""]) {
        [self showAlertMessage:@"Для возможности просмотра истории Вам необходимо либо авторизоватся, либо зарегистрироватся через секцию Настройки!"];
    }
    
    [self loadHistory];
	//Reload the table view
	[self.tableView reloadData];
}

-(void)initPreferences{
	prefManager = [SupTaxiAppDelegate sharedAppDelegate].prefManager;
	
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1];
	
	//self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_header.png"]];
    img.backgroundColor = [UIColor clearColor];
	self.navigationItem.titleView = img;
	[img release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initPreferences];
    
	/*if (![self checkIfAuthenticated]) {
		return;
	}*/
	//[self loadHistory];
}

- (BOOL) checkIfAuthenticated
{
	//Check if user authenticated
	if ([prefManager.prefs.userGuid isEqualToString:@""]) {
		if (registerController && self.navigationController.topViewController == registerController)
			return NO;
		else 
		{[registerController release];
		registerController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
		registerController.delegate = self;
		registerController.selectorOnDone = @selector(loadHistory); 
		[self.navigationController pushViewController:registerController animated:YES];
		return NO;
		}
	}
	return YES;
}

- (void)loadHistory
{
	NSMutableDictionary * d = [NSMutableDictionary dictionaryWithCapacity:2];
	[d setValue:prefManager.prefs.userGuid forKey:USER_GUID_KEY];
	[d setValue:[NSNumber numberWithInt:0] forKey:NEXT_PAGE_KEY];	
	
	[NSThread detachNewThreadSelector:@selector(DowloadHistoryThreadMethod:)
							 toTarget:self 
						   withObject:d];
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

- (void) ReloadTableView:(id)obj
{
	[self.tableView reloadData];
}

#pragma mark UITAbleViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_hItems IsValidIndex:[indexPath row]]) 
	{
		return 70.0f;
	}
	return 44.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if (_hItems) 
	{
		NSInteger count = ([self IsNextPageAvaiable]) ? 1 : 0;
		if (_hItems) 
		{
			count += [_hItems count];
		}
		return count;
	}
	return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	const BOOL isHItemCell = [_hItems IsValidIndex:[indexPath row]];
	NSString * CellIdentifier = isHItemCell ? @"HCell" : @"NextPageCell";
	
	HistoryItemCell *cell = (HistoryItemCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		if (isHItemCell) 
		{
			cell = [[[HistoryItemCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		}
		else
		{
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		}
    }
    
	if (isHItemCell) 
	{
		Order *order = [_hItems objectAtIndex:indexPath.row];
		[cell.lblFromTo setText:[NSString stringWithFormat:@"%@ - %@", order.from, order.to]];
		
		[cell.lblDate setText:order.dateTime];
		[cell.lblStatus setText:[Constants historyStatusById:order.status]];
	}
    else
	{
		NSUInteger leftToLoad = (_totalItemsCount - [_hItems count]);
		if (leftToLoad > ITEMS_PER_PAGE) 
		{
			leftToLoad = ITEMS_PER_PAGE;
		}
		//cell.textLabel.textColor = [UIColor whiteColor];
		[cell.textLabel setText:[NSString stringWithFormat:@"Следущие %d", leftToLoad]];
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	if ([_hItems IsValidIndex:[indexPath row]]) 
	{
		if(detailView == nil)
			detailView = [[HistoryDetailViewController alloc] initWithNibName:@"HistoryDetailViewController" bundle:nil];
		Order *order = [_hItems objectAtIndex:indexPath.row];
		[detailView SetOrder:order];
		
		[self.navigationController pushViewController:detailView animated:YES];
	}
	else
	{
		[self LoadNextPage];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
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