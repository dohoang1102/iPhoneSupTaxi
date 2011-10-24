//
//  OrderViewController.m
//  SupTaxi
//
//  Created by Eugene Zavalko on 29.08.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "OrderViewController.h"
#import "RegisterViewController.h"

#import "BarButtonItemGreenColor.h"
#import "ServerResponce.h"
#import "AppProgress.h"
#import	"SupTaxiAppDelegate.h"

#import "Offer.h"
#import "CarriersViewController.h"

#import "MKOrderNotification.h"

@interface OrderViewController(Private)

- (void) CheckOrderOffersThreadMethod:(id)obj;
- (void) ShowOrderOffers:(id)obj;

- (void) SendOrderThreadMethod:(id)obj;
- (void) ShowOrderResult:(id)obj;
- (void) showAlertMessage:(NSString *)alertMessage;
- (BOOL) textFieldValidate;
- (void) sendOrder;
- (void) performSendOrder:(id)obj;

- (void) clearFields;

- (void) checkOrderOffers:(id)sender;

- (void) CheckInetAndServerThreadMethod:(id)sender;
- (void) ShowConnectionAlert:(id)obj;

- (void) setCurrentOrderId:(NSString *)orderId;
- (NSString *) getCurrentOrderId;

@end

@implementation OrderViewController

#define kSelectButtonIndex 1
#define kCancelButtonIndex 2

#define USER_GUID_KEY @"uGUID"
#define FROM_KEY @"FROMFIELD"
#define TO_KEY @"TOFIELD"
#define DATE_KEY @"DATAFIELD"
#define VTYPE_KEY @"VTYPEFIELD"

#define ISREG_KEY @"ISREG_KEY"
#define SCHE_KEY @"SCHE_KEY"

#define LAT_KEY @"LAT_KEY"
#define LON_KEY @"LON_KEY"
#define FLON_KEY @"FLON_KEY"
#define FLAT_KEY @"FLAT_KEY"
#define TLON_KEY @"TLON_KEY"
#define TLAT_KEY @"TLAT_KEY"
#define FAREA_KEY @"FAREA_KEY"
#define TAREA_KEY @"TAREA_KEY"

@synthesize carTypes = carTypes_;
@synthesize mapViewController;
@synthesize mapViewRouteSearchBar;

@synthesize dateTime = dateTime_;
@synthesize carType = carType_;

@synthesize _orderResponse;
@synthesize _offerResponse;

@synthesize timer;
@synthesize cViewController;

- (void) setCurrentOrderId:(NSString *)orderId
{
    [[SupTaxiAppDelegate sharedAppDelegate] setCurrentOrderId:orderId];
}

- (NSString *) getCurrentOrderId
{
    return [SupTaxiAppDelegate sharedAppDelegate].currentOrderId;
}

- (void) CheckInetAndServerThreadMethod:(id)sender
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	AppProgress * progress = [AppProgress GetDefaultAppProgress];
	
	[progress StartProcessing:@"Проверка интернет соединения"];
	
	ServerResponce * responce = [[ServerResponce alloc] init];
	if (![responce GetAddressListRequest:@"0"]) 
	{
        [self performSelectorOnMainThread:@selector(ShowConnectionAlert:) 
                               withObject:nil 
                            waitUntilDone:NO];
	}else
    {
        [self performSelectorOnMainThread:@selector(performSendOrder:) 
                               withObject:nil 
                            waitUntilDone:NO];
    }
    [responce release];
    
	[progress StopProcessing:@"Готово" andHideTime:0.5];
	
	[pool release];
}

- (void) ShowConnectionAlert:(id)obj
{
	[self showAlertMessage:@"Проверьте интернет соединение!"];
}

- (void) CheckOrderOffersThreadMethod:(id)obj
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	ServerResponce * responce = [[ServerResponce alloc] init];
	if (responce) 
	{
		NSString * guid = (NSString*)obj;
		
		if ([responce GetOffersForOrderRequest:guid])
		{
			NSArray * resultData = [responce GetDataItems];
			if (resultData) {
				self._offerResponse = [resultData objectAtIndex:0]; 
			}
			
			[self performSelectorOnMainThread:@selector(ShowOrderOffers:) 
								   withObject:nil 
								waitUntilDone:NO];
		}else{
            [self performSelectorOnMainThread:@selector(ShowConnectionAlert:) 
                                   withObject:nil 
                                waitUntilDone:NO];
        }
		[responce release];
	}
	
	[pool release];
}

- (void) ShowOrderOffers:(id)obj
{   
    [cViewController release];
	cViewController = [[CarriersViewController alloc] initWithNibName:@"CarriersViewController" bundle:nil];
    [cViewController setOrderId:[self getCurrentOrderId]];
	[cViewController setResponce: _offerResponse];
    [self setCurrentOrderId:nil];
	[self.navigationController pushViewController:cViewController animated:YES];
    [self.tabBarController setSelectedIndex:3];
}


- (void) SendOrderThreadMethod:(id)obj
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	AppProgress * progress = [AppProgress GetDefaultAppProgress];
	[progress StartProcessing:@"Отправка заказа"];
	
	
	ServerResponce * responce = [[ServerResponce alloc] init];
	if (responce) 
	{
		NSDictionary * d = (NSDictionary*)obj;
		NSString * guid = [d objectForKey:USER_GUID_KEY];
		NSString * from = [d objectForKey:FROM_KEY];
		NSString * to = [d objectForKey:TO_KEY];
		NSString * date = [d objectForKey:DATE_KEY];
		NSUInteger vType = [[d objectForKey:VTYPE_KEY] intValue];
		
		BOOL isRegular = [[d objectForKey:ISREG_KEY] boolValue];
		NSString * schedule = [d objectForKey:SCHE_KEY];
		
		float lat = [[d objectForKey:LAT_KEY] floatValue];
		float lon = [[d objectForKey:LON_KEY] floatValue];
		float fLat = [[d objectForKey:FLAT_KEY] floatValue];
		float tLat = [[d objectForKey:TLAT_KEY] floatValue];
		float fLon = [[d objectForKey:FLON_KEY] floatValue];
		float tLon = [[d objectForKey:TLON_KEY] floatValue];
		
        NSString * fromArea = [d objectForKey:FAREA_KEY];
		NSString * toArea = [d objectForKey:TAREA_KEY];
        
		if ([responce SendOrderRequest:guid 
								  from:from 
									to:to 
								  date:date 
						   vehicleType:vType 
                              fromArea:fromArea
                                toArea:toArea
							 isRegular:isRegular 
							  schedule:schedule
							  latitude:lat 
							 longitude:lon 
							   fromLat:fLat 
							   fromLon:fLon 
								 toLat:tLat 
								 toLon:tLon])
		{
			NSArray * resultData = [responce GetDataItems];
			if (resultData && [resultData count]>0) {
				self._orderResponse = [resultData objectAtIndex:0]; 
			}
			
			[self performSelectorOnMainThread:@selector(ShowOrderResult:) 
								   withObject:nil 
								waitUntilDone:NO];
		}else{
            [self setCurrentOrderId:nil];
            [self performSelectorOnMainThread:@selector(ShowConnectionAlert:) 
                                   withObject:nil 
                                waitUntilDone:NO];
        }
		[responce release];
	}
	
	[progress StopProcessing:@"Готово" andHideTime:0.5];
	
	[pool release];
}

- (void) ShowOrderResult:(id)obj
{
	if (!_orderResponse || _orderResponse._result == NO)
		[self showAlertMessage:@"Ошибка отправки заказа, повторите, пожалуйста, позже!"];
	if (_orderResponse._result == YES) {
		[self showAlertMessage:@"Ваш заказ принят на обработку, через 5 минут ожидайте ответ оператора!"];
		[self clearFields];
		
		[self setCurrentOrderId:_orderResponse._guid];
        //set time 60 * 5 (5 min)
        [[MKOrderNotification sharedInstance] scheduleNotificationOn:[NSDate dateWithTimeIntervalSinceNow:30] 
                                                                          text:@"Проверьте предложения от SupTaxi" 
                                                                        action:@"Показать" 
                                                                         sound:nil 
                                                                   launchImage:nil 
                                                                       andInfo:nil];
		
        [[MKOrderNotification sharedInstance] setDelegate:self];
        [[MKOrderNotification sharedInstance] setSelectorOnDone:@selector(checkOrderOffers:)];
		
	}
}

-(void) checkOrderOffers: (id) sender {
    
	[NSThread detachNewThreadSelector:@selector(CheckOrderOffersThreadMethod:)
							 toTarget:self 
						   withObject:[self getCurrentOrderId]];
    //[self setCurrentOrderId:nil];
}

#pragma mark - Action methods viewController

#define kDatePickerTag 100
#define kDateActionsheet 101
- (IBAction)chooseDateTime:(id)sender
{

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Выберите дату и время" delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@"Выбрать", nil];
    [actionSheet showInView:[self.view superview]];
    [actionSheet setFrame:CGRectMake(0, 0, 320, 480)];
    [actionSheet setTag:kDateActionsheet];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, 320, 400)];
    [datePicker setMinuteInterval:10];
    [datePicker setMinimumDate:[NSDate date]];
    [datePicker setTag:kDatePickerTag];
    
    [actionSheet addSubview:datePicker];
    
    [datePicker release];
    [actionSheet release];
}

//
#define kCarPickerTag 200
#define kCarTypeActionsheet 201
- (IBAction)chooseCarType:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Выберите тип автомобиля" delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@"Выбрать", nil];
    [actionSheet showInView:[self.view superview]];
    [actionSheet setFrame:CGRectMake(0, 0, 320, 480)]; //CGRectMake(0, 117, 320, 383)];
    [actionSheet setTag:kCarTypeActionsheet];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 320, 400)];
	pickerView.showsSelectionIndicator = YES;
    pickerView.delegate = self;
    pickerView.dataSource = self;
	
    [pickerView setTag:kCarPickerTag];
    
    int row = 0;
    int counter = 0;
    NSArray * keys = [carTypes_ allValues];
    for (NSString * key in keys) {
        if ([key isEqualToString:self.carType]) {
            row = counter;
            break;
        }
        counter ++;
    }
    NSLog(@"Row %i", row);
    [pickerView selectRow:row inComponent:0 animated:NO];
    
    [actionSheet addSubview:pickerView];
    
    [pickerView release];
    [actionSheet release];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
		  forComponent:(NSInteger)component reusingView:(UIView *)view
{
	NSString *imageName = [[NSString alloc] initWithFormat:@"car_type_%i.png", [[carTypes_.allValues objectAtIndex: row] intValue]];
	UIImageView *temp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];  
	[imageName release];
	temp.frame = CGRectMake(0, 0, 61, 25);
	UILabel *channelLabel = [[UILabel alloc] initWithFrame:CGRectMake(63, 0, 100, 25)];
	channelLabel.text = [carTypes_.allKeys objectAtIndex:row];
	channelLabel.textAlignment = UITextAlignmentLeft;
	channelLabel.backgroundColor = [UIColor clearColor];
	
	UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 170, 29)];
	[tmpView insertSubview:temp atIndex:0];
	[tmpView insertSubview:channelLabel atIndex:1];
	[temp release];
	[channelLabel release];
	return [tmpView autorelease];
}

-(void)initPreferences{
	//Creating and adding MapViewController
	MapViewController *newMapViewController = [[MapViewController alloc] init];
	[[newMapViewController view] setFrame:[[self view] bounds]];
	[[self view] addSubview:[newMapViewController view]];
	self.mapViewController = newMapViewController;
	[newMapViewController setMapManipulationsEnabled:YES];
	[newMapViewController release];
	
	MapViewRouteSearchBar *searchBar = [[MapViewRouteSearchBar alloc] init];
	[newMapViewController setMapViewSearchBar:searchBar];
	[searchBar setParentController:self];
	self.mapViewRouteSearchBar = searchBar;
	[searchBar release];
	
	[self.mapViewRouteSearchBar initWithSelfLocation];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (!self.mapViewRouteSearchBar.addressSelect) {
        [self clearFields];
    }
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self.mapViewRouteSearchBar setDaysVisible:prefManager.prefs.userHasRegularOrder];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    [self setCurrentOrderId:nil];
    
	prefManager = [SupTaxiAppDelegate sharedAppDelegate].prefManager;
	
	carTypes_ = [[NSDictionary alloc] initWithObjectsAndKeys:@"1", @"Эконом", @"2", @"Грузовой", @"3", @"VIP", nil];
	
	UIColor *color = [UIColor colorWithRed:16.0/255.0 green:79.0/255.0 blue:13.0/255.0 alpha:1];
	
    UIBarButtonItem *clearBtn = [UIBarButtonItem barButtonItemWithTint:color andTitle:@"Очистить" andTarget:self andSelector:@selector(clearForm:)];
    self.navigationItem.leftBarButtonItem = clearBtn;
	
    UIBarButtonItem *orderButton = [UIBarButtonItem barButtonItemWithTint:color andTitle:@"Заказать" andTarget:self andSelector:@selector(orderTaxi:)];
    self.navigationItem.rightBarButtonItem = orderButton;
    
	UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_header.png"]];
    img.backgroundColor = [UIColor clearColor];
	self.navigationItem.titleView = img;
	[img release];
	
	[self initPreferences];
    
    [self.mapViewRouteSearchBar.carImageView setImage:[UIImage imageNamed:@"car_type_1.png"]];
	NSString * carTypeKey = [NSString stringWithString:[carTypes_.allKeys objectAtIndex:1]];
    [self.mapViewRouteSearchBar.carTypeLabel setText:carTypeKey];
    [self setCarType:@"1"];
}

- (IBAction)clearForm:(id)sender
{
	[self clearFields];
}

-(void) clearFields
{
	[self.mapViewRouteSearchBar clearData];
	[self.mapViewRouteSearchBar.carImageView setImage:[UIImage imageNamed:@"car_type_1.png"]];
	NSString * carTypeKey = [NSString stringWithString:[carTypes_.allKeys objectAtIndex:1]];
	[self.mapViewRouteSearchBar.carTypeLabel setText:carTypeKey];
    [self setCarType:@"1"];
}

-(BOOL)textFieldValidate {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Пожалуйста, заполните все поля." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	NSMutableArray *fieldArray = [[NSMutableArray alloc] init];
	int i = 0;
	
    [fieldArray addObject:[NSString stringWithFormat:@"%@",self.mapViewRouteSearchBar.fromField.text]];
    [fieldArray addObject:[NSString stringWithFormat:@"%@",self.mapViewRouteSearchBar.toField.text]];
    [fieldArray addObject:[NSString stringWithFormat:@"%@",self.mapViewRouteSearchBar.timeField.text]];
    if (prefManager.prefs.userHasRegularOrder)
        [fieldArray addObject:[NSString stringWithFormat:@"%@",self.mapViewRouteSearchBar.daysField.text]];
	
	@try {
		for (NSString *fieldText in fieldArray){
			if([fieldText isEqualToString:@""]){
				[alert show]; 
				return NO;
				break;
			}
			i++;
		}
		
		// check that all the field were passed (i == array.count) if so execute
		if(i == [[NSNumber numberWithInt: fieldArray.count] intValue]){
			
			//if all the data entered, let's check coordinates
			if (![self.mapViewRouteSearchBar validate]) {
				UIAlertView *coordAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Не определено текущее месторасположение" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[coordAlert show];
				[coordAlert release];
				return NO;
			}
			
			return YES;        
		}
	}
	@catch (NSException * e) {
		NSLog(@"%@", e);
	}
	@finally {
		[alert release];
		[fieldArray release];
	}
	return NO;
}

- (IBAction)orderTaxi:(id)sender
{
    [NSThread detachNewThreadSelector:@selector(CheckInetAndServerThreadMethod:)
							 toTarget:self 
						   withObject:nil];
}

- (void) performSendOrder:(id)obj
{
    if ([self textFieldValidate] == NO) return;
	
    if ([self getCurrentOrderId] != nil) {
        [self showAlertMessage:@"Вы не можете осуществить заказ пока не прийдет ответ на ваш предыдущий заказ!"];
        return;
    }
    
	if ([prefManager.prefs.userGuid isEqualToString:@""]) {
		RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
		registerViewController.delegate = self;
		registerViewController.selectorOnDone = @selector(sendOrder); 
		[self.navigationController pushViewController:registerViewController animated:YES];
		[registerViewController release];
		return;
	}
	[self sendOrder];

}

- (void) sendOrder
{
	NSMutableDictionary * d = [NSMutableDictionary dictionaryWithCapacity:11];
	[d setValue:[NSNumber numberWithUnsignedInteger:[carType_ intValue]] forKey:VTYPE_KEY];
	[d setValue:prefManager.prefs.userGuid forKey:USER_GUID_KEY];
	
	NSString * from = (self.mapViewRouteSearchBar.placeMarkFrom == nil || [self.mapViewRouteSearchBar.placeMarkFrom.shortAddress isEqualToString:@""])? self.mapViewRouteSearchBar.fromField.text : self.mapViewRouteSearchBar.placeMarkFrom.shortAddress;
	NSString * to = (self.mapViewRouteSearchBar.placeMarkTo == nil || [self.mapViewRouteSearchBar.placeMarkTo.shortAddress isEqualToString:@""])? self.mapViewRouteSearchBar.toField.text : self.mapViewRouteSearchBar.placeMarkTo.shortAddress;
    
	[d setValue:from forKey:FROM_KEY];
	[d setValue:to forKey:TO_KEY];
	[d setValue:self.mapViewRouteSearchBar.timeField.text forKey:DATE_KEY];
	[d setValue:[NSString stringWithFormat:@"%i", (int)prefManager.prefs.userHasRegularOrder] forKey:ISREG_KEY];
    [d setValue:self.mapViewRouteSearchBar.daysField.text forKey:SCHE_KEY];

	[d setValue:[NSString stringWithFormat:@"%f", self.mapViewRouteSearchBar.selfLocationPlacemark.coordinate.latitude] forKey:LAT_KEY];
	[d setValue:[NSString stringWithFormat:@"%f", self.mapViewRouteSearchBar.selfLocationPlacemark.coordinate.longitude] forKey:LON_KEY];
	[d setValue:[NSString stringWithFormat:@"%f", self.mapViewRouteSearchBar.placeMarkFrom.coordinate.latitude] forKey:FLAT_KEY];
	[d setValue:[NSString stringWithFormat:@"%f", self.mapViewRouteSearchBar.placeMarkFrom.coordinate.longitude]forKey:FLON_KEY];
	[d setValue:[NSString stringWithFormat:@"%f", self.mapViewRouteSearchBar.placeMarkTo.coordinate.latitude] forKey:TLAT_KEY];
	[d setValue:[NSString stringWithFormat:@"%f", self.mapViewRouteSearchBar.placeMarkTo.coordinate.longitude] forKey:TLON_KEY];

    [d setValue:self.mapViewRouteSearchBar.placeMarkFrom.cityArea forKey:FAREA_KEY];
	[d setValue:self.mapViewRouteSearchBar.placeMarkTo.cityArea forKey:TAREA_KEY];
    
	[NSThread detachNewThreadSelector:@selector(SendOrderThreadMethod:)
							 toTarget:self 
						   withObject:d];
}

#pragma mark - UIPickerViewDelegate methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@", [[carTypes_ allKeys] objectAtIndex:row]];
}

#pragma mark - UIPickerViewDataSource methods
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [carTypes_ count];
}

#pragma mark - UIActionSheetDelegate methods

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    NSArray *subviews = [actionSheet subviews];
    
    [[subviews objectAtIndex:kSelectButtonIndex] setFrame:CGRectMake(20, 366, 280, 46)];
    [[subviews objectAtIndex:kCancelButtonIndex] setFrame:CGRectMake(20, 417, 280, 46)];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        if (actionSheet.tag == kDateActionsheet) {
            NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
            
            [dateFomatter setDateFormat:@"YYYY-MM-dd HH:mm"];
            UIDatePicker *picker = (UIDatePicker *)[actionSheet viewWithTag:kDatePickerTag];
            NSDate *selectDate = [picker date];
            dateTime_ = [NSString stringWithFormat:@"%@", [dateFomatter stringFromDate:selectDate]];
            NSLog(@"%@",dateTime_);
			[self.mapViewRouteSearchBar.timeField setText:dateTime_];
            [dateFomatter release];
        } 
        else if (actionSheet.tag == kCarTypeActionsheet){
            UIPickerView *picker = (UIPickerView *)[actionSheet viewWithTag:kCarPickerTag];
            NSInteger rowIndex = [picker selectedRowInComponent:0];
            NSString *key = [[picker delegate] pickerView:picker titleForRow:rowIndex forComponent:0];
            carType_ = [[NSString alloc] initWithString:[carTypes_ objectForKey:key]];
			NSLog(@"%@",carType_);
			NSString *imageName = [NSString stringWithFormat:@"car_type_%@.png", carType_];
            NSLog(@"%@",imageName);
			UIImage *img = [UIImage imageNamed:imageName];
			[self.mapViewRouteSearchBar.carImageView setImage:img];
			NSString * carTypeKey = [NSString stringWithString:[carTypes_.allKeys objectAtIndex:rowIndex]];
			NSLog(@"%@",carTypeKey);
			[self.mapViewRouteSearchBar.carTypeLabel setText:carTypeKey];
			
        }
    }
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.carTypes = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[carTypes_ release];
    
	[timer release];
	[mapViewController release];
	[mapViewRouteSearchBar release];
	[cViewController release];
    [dateTime_ release];
    [carType_ release];
	
	[_orderResponse release];
	
    [super dealloc];
}


@end
