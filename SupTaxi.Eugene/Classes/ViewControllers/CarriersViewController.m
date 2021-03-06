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
- (IBAction)rowImageClick:(id)sender;
- (UILabel *)newLabel:(CGRect)frame;

@end

@implementation CarriersViewController

#define USER_GUID_KEY @"uGUID"
#define ORDERID_KEY @"ORDERID_KEY"
#define CID_KEY @"CID_KEY"

@synthesize headerView = headerView_;
@synthesize footerView = footerView_;
@synthesize innerFooterView = innerFooterView_;
@synthesize innerOfferFooterView = innerOfferFooterView_;
@synthesize backgroundImage = backgroundImage_;
@synthesize lblFromTo = lblFromTo_;

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

- (void) SendOrderRejectThreadMethod:(id)obj
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	AppProgress * progress = [AppProgress GetDefaultAppProgress];
	[progress StartProcessing:@"Отмена заказа"];
	
	
	ServerResponce * responce = [[ServerResponce alloc] init];
	if (responce) 
	{
		NSDictionary * d = (NSDictionary*)obj;
		NSString * guid = [d objectForKey:USER_GUID_KEY];
		NSInteger oId = [[d objectForKey:CID_KEY] intValue];
		
		if ([responce SendOrderRejectRequest:guid orderId:oId])
		{
			NSArray * resultData = [responce GetDataItems];
			if (resultData) {
				self._orderResponse = [resultData objectAtIndex:0]; 
			}
			
			[self performSelectorOnMainThread:@selector(ShowOrderRejectResult:) 
								   withObject:nil 
								waitUntilDone:NO];
		}
		[responce release];
	}
	
	[progress StopProcessing:@"Готово" andHideTime:0.5];
	
	[pool release];
}

- (void) ShowOrderRejectResult:(id)obj
{
    if (!_orderResponse)
		[self showAlertMessage:@"Ошибка при запросе!"];
	[tableView_ reloadData];
	if (_orderResponse._result == YES) {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (void) ShowOrderAcceptResult:(id)obj
{
	if (!_orderResponse || _orderResponse._result == NO)
		[self showAlertMessage:@"Ошибка подтверждения заказа, повторите, пожалуйста, еще раз!"];
	[tableView_ reloadData];
	if (_orderResponse._result == YES) {
		[self.navigationController popViewControllerAnimated:YES];
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
    [lblFromTo_ release];
    [innerOfferFooterView_ release];
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
    [innerOfferFooterView_ setHidden:YES];
    innerOfferFooterView_.layer.cornerRadius = 10;
    
    [lblFromTo_ setText:[NSString stringWithFormat:@"%@ - %@", _resultResponse._from, _resultResponse._to]];
    
    UIColor *color = [UIColor colorWithRed:16.0/255.0 green:79.0/255.0 blue:13.0/255.0 alpha:1];
    UIBarButtonItem *backButton = [UIBarButtonItem barButtonItemWithTint:color andTitle:@"Отмена" andTarget:self andSelector:@selector(backAction:)];
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
    img.backgroundColor = [UIColor clearColor];
	self.navigationItem.titleView = img;
	[img release];
	
    // делаем невидимой кнопку назад
    [self.navigationItem setHidesBackButton:YES];
}

- (void) setOrderId:(NSString*) orderId
{
    currentOrderId = orderId;
}

- (IBAction)backAction:(id)sender
{
    NSMutableDictionary * d = [NSMutableDictionary dictionaryWithCapacity:2];
	[d setValue:prefManager.prefs.userGuid forKey:USER_GUID_KEY];
	[d setValue:[NSString stringWithFormat:@"%i", [currentOrderId intValue]] forKey:CID_KEY];
	
	[NSThread detachNewThreadSelector:@selector(SendOrderRejectThreadMethod:)
							 toTarget:self 
						   withObject:d];
    
	//[self.navigationController popViewControllerAnimated:YES];
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
	return 94.0;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderShowCell *cell = (OrderShowCell *)[tableView dequeueReusableCellWithIdentifier:@"CellId"];
    if (cell == nil) {
        cell = [[[OrderShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellId"] autorelease];        
    }
    
    Offer *offer = [_resultResponse._offers objectAtIndex:indexPath.row];
    
    [cell.carrierLogo setOffer:offer];
    
    [[cell.carrierLogo imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [cell.carrierLogo setImage:offer.carrierLogo forState:UIControlStateNormal];
    [cell.carrierLogo setImage:offer.carrierLogo forState:UIControlStateSelected];
    [cell.carrierLogo setImage:offer.carrierLogo forState:UIControlStateHighlighted];
    [cell.carrierLogo addTarget:self action:@selector(rowImageClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.timeLabel.text = [NSString stringWithFormat:@"~ %d минут*", offer.arrivalTime]; 
    cell.priceLabel.text = [NSString stringWithFormat:@"%d руб**", offer.minPrice]; 
	[cell.switcher setOn:NO];
	[cell.switcher setTag:indexPath.row];
    [cell.switcher addTarget:self action:@selector(changeSelection:) forControlEvents:UIControlEventValueChanged];
    return cell;
}

- (IBAction)rowImageClick:(id)sender
{
    for (UIView* view in innerOfferFooterView_.subviews) {
        [view removeFromSuperview];
    }
    Offer *offer = [(UIOfferImage *)sender offer];
    UILabel *lblTarif = [self newLabel:CGRectMake(5, 5, innerOfferFooterView_.frame.size.width - 10, innerOfferFooterView_.frame.size.height - 10)];
    [lblTarif setTag:1];
    [lblTarif setBackgroundColor:[UIColor clearColor]];
    [lblTarif setText:offer.carrierDescription];
    
    [innerOfferFooterView_ addSubview:lblTarif];
    [lblTarif release];
    [innerFooterView_ setHidden:YES];
    [innerOfferFooterView_ setHidden:NO];
}

- (UILabel *)newLabel:(CGRect)frame
{
    UILabel *newLabel = [[UILabel alloc] initWithFrame:frame];
    newLabel.textAlignment = UITextAlignmentLeft;
    [newLabel setLineBreakMode:UILineBreakModeWordWrap];
    [newLabel setNumberOfLines:2];
    newLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
    newLabel.backgroundColor = [UIColor whiteColor];
    newLabel.opaque = YES;
    
    return newLabel;
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
