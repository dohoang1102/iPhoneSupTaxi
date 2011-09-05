//
//  CarrierListViewController.m
//  SupTaxi
//
//  Created by Eugene Zavalko on 01.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "CarriersViewController.h"
#import "Response.h"
#import "Offer.h"
#import <QuartzCore/QuartzCore.h>
#import "OrderShowCell.h"
#import "BarButtonItemGreenColor.h"

#import "ServerResponce.h"
#import "AppProgress.h"
#import "SupTaxiAppDelegate.h"

@interface CarriersViewController(Private)

- (IBAction)changeSelection:(id)sender;
- (IBAction)backAction:(id)sender;

- (void) SendOrderAcceptThreadMethod:(id)obj;
- (void) ShowOrderAcceptResult:(id)obj;
- (void) showAlertMessage:(NSString *)alertMessage;

@end

@implementation CarriersViewController

#define USER_GUID_KEY @"uGUID"
#define ORDERID_KEY @"ORDERID_KEY"
#define CID_KEY @"CID_KEY"

@synthesize headerView = headerView_;
@synthesize footerView = footerView_;
@synthesize innerFooterView = innerFooterView_;
@synthesize backgroundImage = backgroundImage_;

@synthesize _resultResponse;
@synthesize _orderResponse;

@synthesize tableView = tableView_;

- (void) SendOrderAcceptThreadMethod:(id)obj
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	AppProgress * progress = [AppProgress GetDefaultAppProgress];
	[progress StartProcessing:@"Подтверждение заказа"];
	
	
	ServerResponce * responce = [[ServerResponce alloc] init];
	if (responce) 
	{
		NSDictionary * d = (NSDictionary*)obj;
		NSString * guid = [d objectForKey:USER_GUID_KEY];
		NSString * orderId = [d objectForKey:ORDERID_KEY];
		NSString * carrierId = [d objectForKey:CID_KEY];
		
		if ([responce SendOrderAcceptWithOfferRequest:guid 
											  orderId:orderId 
											carrierId:carrierId ])
		{
			NSArray * resultData = [responce GetDataItems];
			if (resultData) {
				self._orderResponse = [resultData objectAtIndex:0]; 
			}
			
			[self performSelectorOnMainThread:@selector(ShowOrderAcceptResult:) 
								   withObject:nil 
								waitUntilDone:NO];
		}
		[responce release];
	}
	
	
	[progress StopProcessing:@"Готово" andHideTime:0.5];
	
	[pool release];
}

- (void) ShowOrderAcceptResult:(id)obj
{
	if (!_orderResponse || _orderResponse._result == NO)
		[self showAlertMessage:@"Ошибка подтверждения заказа, повторите, пожалуйста, еще раз!"];
	[tableView_ reloadData];
	if (_orderResponse._result == YES) {
		[self showAlertMessage:@"Ваш заказ принят, ожидайте машину!"];
	}
}

#pragma mark Init

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
    [headerView_ release];
    [footerView_ release];
    [innerFooterView_ release];
    [tableView_ release];
	[_orderResponse release];
    [_resultResponse release];
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
	
    headerView_.backgroundColor = [UIColor clearColor];
    innerFooterView_.layer.cornerRadius = 10;
    
    UIColor *buttonColor = [UIColor colorWithRed:2.0/255.0 green:12.0/255.0 blue:2.0/255.0 alpha:1];
    UIBarButtonItem *backButton = [UIBarButtonItem barButtonItemWithTint:buttonColor andTitle:@"Отмена" andTarget:self andSelector:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1];
    
    // делаем прозрачным бэкграунд таблицы
    NSArray *subviews = [self.view subviews];
    for (UIView *view in subviews) 
    {
        if ([view isKindOfClass:[UITableView class]]) 
        {
			UITableView *tbView = (UITableView *)view;
			tbView.allowsSelection = NO;
            view.backgroundColor = [UIColor clearColor];
        }
    }
    
	UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_header.png"]];
	self.navigationItem.titleView = img;
	[img release];
	
    // делаем невидимой кнопку назад
    [self.navigationItem setHidesBackButton:YES];
}

- (IBAction)backAction:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
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

#pragma mark -
#pragma UITableViewDelegate methods
// высота каждой ячейки
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

// высота шапки
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section 
{
	return 50.0;
}

// высота нижней части
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section 
{
	return 120.0;
}

// шапка таблицы
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{    
    return headerView_;
}

// нижняя часть таблицы
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section 
{    
    return footerView_;
}

#pragma mark -
#pragma UITableViewDataSourceDelegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	//NSLog(@"OffersCount: %i", [_resultResponse._offers count]);
    return [_resultResponse._offers count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIImage *)getImageWithCarrierName:(NSString *)carrierName
{
    UIImage *image = [UIImage imageNamed:@"car_type_1.png"];
    return image;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderShowCell *cell = (OrderShowCell *)[tableView dequeueReusableCellWithIdentifier:@"CellId"];
    if (cell == nil) {
        cell = [[[OrderShowCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"CellId"] autorelease];        
    }
    
    Offer *offer = [_resultResponse._offers objectAtIndex:indexPath.row];
    
    cell.carrierLogo.image = [self getImageWithCarrierName:offer.carrierName];
    cell.timeLabel.text = [NSString stringWithFormat:@"~ %d минут*", offer.arrivalTime]; 
    cell.priceLabel.text = [NSString stringWithFormat:@"%d руб**", offer.minPrice]; 
	[cell.switcher setOn:NO];
	[cell.switcher setTag:indexPath.row];
    [cell.switcher addTarget:self action:@selector(changeSelection:) forControlEvents:UIControlEventValueChanged];
    return cell;
}

- (IBAction)changeSelection:(id)sender
{
	UICustomSwitch  *senderSwitch = (UICustomSwitch *)sender;
	BOOL result = [senderSwitch isOn];
	int index = senderSwitch.tag;
	NSLog(@"Sender Switch : %d Tag: %i", (int)result, index);
	
	Offer *offer = [_resultResponse._offers objectAtIndex:index];
		
	NSMutableDictionary * d = [NSMutableDictionary dictionaryWithCapacity:3];
	[d setValue:prefManager.prefs.userGuid forKey:USER_GUID_KEY];
	[d setValue:[NSString stringWithFormat:@"%i", offer.orderId] forKey:ORDERID_KEY];
	[d setValue:[NSString stringWithFormat:@"%i", offer.carrierGuid] forKey:CID_KEY];
	
	[NSThread detachNewThreadSelector:@selector(SendOrderAcceptThreadMethod:)
							 toTarget:self 
						   withObject:d];
	
}

- (void) setResponce:(ResponseOffers*) obj
{
	self._resultResponse = obj;
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
