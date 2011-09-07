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
			/*
			_totalPagesCount = [responce GetNavigatePages];
			_pagesLoadedCount = [responce GetNavigatePage];
			_totalItemsCount = [responce GetNavigateCount];
			*/
			NSArray * resultData = [responce GetDataItems];
			if (resultData) {
				self._historyResponse = [resultData objectAtIndex:0]; 
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
/*
- (void) LoadNextPage
{
	const NSUInteger nextPageNumber = (_pagesLoadedCount + 1);
	
	NSMutableDictionary * d = [NSMutableDictionary dictionaryWithCapacity:2];
	[d setValue:[NSNumber numberWithUnsignedInteger:nextPageNumber] forKey:NEXT_PAGE_KEY];
	[d setValue:[NSNumber numberWithUnsignedInteger:[]] forKey:CHANNEL_ID_KEY];
	
	NSLog(@"\nPlotsTableViewController DowloadStories page=%d for %@", nextPageNumber, _channel);
	
	[NSThread detachNewThreadSelector:@selector(DowloadStoriesThreadMethod:)
							 toTarget:self 
						   withObject:d];
}
*/

-(NSArray *)orders{
	return _historyResponse._orders;
	//return [[LocalOrderDCManager instance] lastQueryObjects];
}

- (void)dealloc
{	
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
	[self checkIfAuthenticated];
	//Reload the table view
	[self.tableView reloadData];
}

-(void)initPreferences{
	prefManager = [SupTaxiAppDelegate sharedAppDelegate].prefManager;
	
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1];
	
	//self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_header.png"]];
	self.navigationItem.titleView = img;
	[img release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initPreferences];
	
	if ([self checkIfAuthenticated]) {
		[self loadHistory];
	}
}

- (BOOL) checkIfAuthenticated
{
	//Check if user authenticated
	if ([prefManager.prefs.userGuid isEqualToString:@""]) {
		RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
		registerViewController.delegate = self;
		registerViewController.selectorOnDone = @selector(loadHistory); 
		[self.navigationController pushViewController:registerViewController animated:YES];
		[registerViewController release];
		return NO;
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
/*
- (BOOL) IsNextPageAvaiable
{
	if (_totalItemsCount > 0) 
	{
		if (orders == nil) 
		{
			return YES;
		}
		return ([orders count] < _totalItemsCount);
	}
	return NO;
}
*/
#pragma mark UITAbleViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if ([self orders]) 
	{/*
		NSInteger count = ([self IsNextPageAvaiable]) ? 1 : 0;
		if (_stories) 
		{
			count += [_historyResponse._orders count];
		}
		return count;
	  */
		return [[self orders] count];
	}
	return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	HistoryItemCell *cell = (HistoryItemCell *)[tableView dequeueReusableCellWithIdentifier:@"CellId"];
    if (cell == nil) {
        cell = [[[HistoryItemCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"CellId"] autorelease];        
    }
    
    Order *order = [[self orders] objectAtIndex:indexPath.row];
    [cell.lblFromTo setText:[NSString stringWithFormat:@"%@ - %@", order.from, order.to]];
	
	[cell.lblDate setText:order.dateTime];
	[cell.lblStatus setText: (order.status)? @"Выполнен": @"В ожидании"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	if(detailView == nil)
		detailView = [[HistoryDetailViewController alloc] initWithNibName:@"HistoryDetailViewController" bundle:nil];
	Order *order = [[self orders] objectAtIndex:indexPath.row];
	[detailView SetOrder:order];
	
	[self.navigationController pushViewController:detailView animated:YES];
}

@end