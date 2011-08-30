//
//  OrderViewController.m
//  SupTaxi
//
//  Created by Eugene Zavalko on 29.08.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "OrderViewController.h"
#import "BarButtonItemGreenColor.h"
#import "ServerResponce.h"
#import "AppProgress.h"

@interface OrderViewController(Private)

- (void) SendOrderThreadMethod:(id)obj;
- (void) ShowOrderResult:(id)obj;

@end

@implementation OrderViewController

#define kSelectButtonIndex 1
#define kCancelButtonIndex 2

#define USER_GUID_KEY @"uGUID"
#define FROM_KEY @"FROMFIELD"
#define TO_KEY @"TOFIELD"
#define DATE_KEY @"DATAFIELD"
#define VTYPE_KEY @"VTYPEFIELD"

@synthesize carTypes = carTypes_;

@synthesize fromPoint = fromPoint_;
@synthesize toPoint = toPoint_;
@synthesize dateTime = dateTime_;
@synthesize carType = carType_;

@synthesize txtDateTime;
@synthesize lblCarType;
@synthesize imgCarType;

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
		
		if ([responce SendOrderRequestNotRegular:guid 
											from:from 
											  to:to 
											date:date 
									 vehicleType:vType ])
		{
			NSArray * resultData = [responce GetDataItems];
			if (resultData) {
				_orderResponse = [resultData objectAtIndex:0]; 
			}
			
			[self performSelectorOnMainThread:@selector(ShowOrderResult:) 
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
	NSLog(@"%@", _orderResponse._result);
}

#pragma mark - Action methods viewController

#define kDatePickerTag 100
#define kDateActionsheet 101
- (IBAction)chooseDateTime:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Выберите дату и время" delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@"Выбрать", nil];
    [actionSheet showInView:[self.view superview]];
    [actionSheet setFrame:CGRectMake(0, 117, 320, 383)];
    [actionSheet setTag:kDateActionsheet];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, 320, 300)];
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
    [actionSheet setFrame:CGRectMake(0, 117, 320, 383)];
    [actionSheet setTag:kCarTypeActionsheet];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 320, 300)];
	pickerView.showsSelectionIndicator = YES;
    pickerView.delegate = self;
    pickerView.dataSource = self;
	
    [pickerView setTag:kCarPickerTag];
    
    [actionSheet addSubview:pickerView];
    
    [pickerView release];
    [actionSheet release];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
		  forComponent:(NSInteger)component reusingView:(UIView *)view
{
	NSString *imageName = [[NSString alloc] initWithFormat:@"car_type_%i.png", [[carTypes_.allValues objectAtIndex: row] intValue]];
	UIImageView *temp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];        
	temp.frame = CGRectMake(0, 0, 61, 25);
	UILabel *channelLabel = [[UILabel alloc] initWithFrame:CGRectMake(63, 0, 100, 25)];
	channelLabel.text = [carTypes_.allKeys objectAtIndex:row];
	channelLabel.textAlignment = UITextAlignmentLeft;
	channelLabel.backgroundColor = [UIColor clearColor];
	
	UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 170, 29)];
	[tmpView insertSubview:temp atIndex:0];
	[tmpView insertSubview:channelLabel atIndex:1];
	[temp release];
	return tmpView;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	carType_ = @"1";
	
	carTypes_ = [[NSDictionary alloc] initWithObjectsAndKeys:@"1", @"Эконом",
				 @"2", @"Бизнес",
				 @"3", @"Грузовой", nil];
	
	UIColor *color = [UIColor colorWithRed:16.0/255.0 green:79.0/255.0 blue:13.0/255.0 alpha:1];
	
	// кнопка очистить
    UIBarButtonItem *clearBtn = [UIBarButtonItem barButtonItemWithTint:color andTitle:@"Очистить" andTarget:self andSelector:@selector(clearForm:)];
    self.navigationItem.leftBarButtonItem = clearBtn;
    [clearBtn release];
    
    UIBarButtonItem *orderButton = [UIBarButtonItem barButtonItemWithTint:color andTitle:@"Заказать" andTarget:self andSelector:@selector(orderTaxi:)];
    self.navigationItem.rightBarButtonItem = orderButton;
    [orderButton release];
	
	UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_header.png"]];
	self.navigationItem.titleView = img;
	[img release];
}

- (IBAction)clearForm:(id)sender
{
    
}

- (IBAction)orderTaxi:(id)sender
{
    NSMutableDictionary * d = [NSMutableDictionary dictionaryWithCapacity:5];
	[d setValue:[NSNumber numberWithUnsignedInteger:[carType_ intValue]] forKey:VTYPE_KEY];
	[d setValue:@"4" forKey:USER_GUID_KEY];
	[d setValue:fromPoint_.text forKey:FROM_KEY];
	[d setValue:toPoint_.text forKey:TO_KEY];
	[d setValue:txtDateTime.text forKey:DATE_KEY];
	
	[NSThread detachNewThreadSelector:@selector(SendOrderThreadMethod:)
							 toTarget:self 
						   withObject:d];
}

#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
    
    [[subviews objectAtIndex:kSelectButtonIndex] setFrame:CGRectMake(20, 266, 280, 46)];
    [[subviews objectAtIndex:kCancelButtonIndex] setFrame:CGRectMake(20, 317, 280, 46)];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        if (actionSheet.tag == kDateActionsheet) {
            NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
            
            [dateFomatter setDateFormat:@"YYYY-MM-dd HH:mm"];
            UIDatePicker *picker = (UIDatePicker *)[actionSheet viewWithTag:kDatePickerTag];
            NSDate *selectDate = [picker date];
            dateTime_ = [[NSString alloc] initWithFormat:@"%@", [dateFomatter stringFromDate:selectDate]];
            NSLog(@"%@",dateTime_);
			[self.txtDateTime setText:dateTime_];
            [dateFomatter release];
        } 
        else if (actionSheet.tag == kCarTypeActionsheet){
            UIPickerView *picker = (UIPickerView *)[actionSheet viewWithTag:kCarPickerTag];
            NSInteger rowIndex = [picker selectedRowInComponent:0];
            NSString *key = [[picker delegate] pickerView:picker titleForRow:rowIndex forComponent:0];
            carType_ = [[NSString alloc] initWithString:[carTypes_ objectForKey:key]];
			NSLog(@"%@",carType_);
			NSString *imageName = [[NSString alloc] initWithFormat:@"car_type_%@.png", carType_];
			UIImage *img = [UIImage imageNamed:imageName];
			[self.imgCarType setImage:img];
			[imageName release];
			NSString * carTypeKey = [[NSString alloc] initWithString:[carTypes_.allKeys objectAtIndex:rowIndex]];
			NSLog(@"%@",carTypeKey);
			[self.lblCarType setText:carTypeKey];
			
        }
    }
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
    
	[txtDateTime release];
	[lblCarType release];
	[imgCarType release];
	
    [fromPoint_ release];
    [toPoint_ release];
    [dateTime_ release];
    [carType_ release];
	
    [super dealloc];
}


@end
