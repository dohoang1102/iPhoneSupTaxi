    //
//  ContractViewController.m
//  SupTaxi
//
//  Created by Eugene Zavalko on 04.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "ContractViewController.h"
#import "BarButtonItemGreenColor.h"
#import "ServerResponce.h"
#import "AppProgress.h"
#import "SupTaxiAppDelegate.h"

@interface ContractViewController(Private)

- (void) showAlertMessage:(NSString *)alertMessage;

- (BOOL) textFieldValidate;
- (void) textFieldUnFocus;

- (void) UpdateThreadMethod:(id)obj;
- (void) UpdateResult:(id)obj;

- (void) contractSave:(id)sender;
- (void) contractDecline:(id)sender;

@end

@implementation ContractViewController

#define CNUMB_KEY @"UNAME"
#define CCUST_KEY @"ULNAME"
#define CCARR_KEY @"UPHONE"

@synthesize txtContractNumber;
@synthesize txtContractCustomer;
@synthesize txtContractCarrier;

@synthesize _updateResponse;

@synthesize selectorOnDone;
@synthesize delegate;

#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) UpdateThreadMethod:(id)obj
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	AppProgress * progress = [AppProgress GetDefaultAppProgress];
	[progress StartProcessing:@"Регистрация"];
	
	
	ServerResponce * responce = [[ServerResponce alloc] init];
	if (responce) 
	{
		NSDictionary * d = (NSDictionary*)obj;
		NSString * number = [d objectForKey:CNUMB_KEY];
		NSString * customer = [d objectForKey:CCUST_KEY];
        NSString * carrier = [d objectForKey:CCARR_KEY];
		
		if ([responce UpdateUserRequest:prefManager.prefs.userGuid
                               password:prefManager.prefs.userPassword
                                  email:prefManager.prefs.userEmail
                              firstName:prefManager.prefs.userFirstName
                             secondName:prefManager.prefs.userSecondName
                                   city:prefManager.prefs.userCity
                                cNumber:number
                              cCustomer:customer
                               cCarrier:carrier
                                  phone:prefManager.prefs.userPhone])
		{
			NSArray * resultData = [responce GetDataItems];
			if (resultData) {
				self._updateResponse = [resultData objectAtIndex:0]; 
			}
			
			[self performSelectorOnMainThread:@selector(UpdateResult:) 
								   withObject:nil 
								waitUntilDone:NO];
		}
		[responce release];
	}
	
	
	[progress StopProcessing:@"Готово" andHideTime:0.5];
	
	[pool release];
}

- (void) UpdateResult:(id)obj
{
	if (!_updateResponse)
	{
		[self showAlertMessage:@"Ошибка запроса обновления!"];
		return;
	}
	
	if (_updateResponse._result == NO) //ошибка обновления:
	{
		[self showAlertMessage:@"Не удалось обновить данные, попробуйте еще раз!"];
		return;	
	}
	else if (_updateResponse._result == YES) //все ок
	{
        // need to save contract locally
        [prefManager updateUserHasContract:YES];
        [prefManager updateUserContractWithNumber:txtContractNumber.text 
                                 contractCustomer:txtContractCustomer.text 
                               andContractCarrier:txtContractCarrier.text];
        
        [self.navigationController popViewControllerAnimated:YES];
        if (self.delegate){
			[self.delegate performSelector:selectorOnDone];
		}
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	prefManager = [SupTaxiAppDelegate sharedAppDelegate].prefManager;
    
    [self.txtContractNumber setText:prefManager.prefs.userContractNumber];
    [self.txtContractCustomer setText:prefManager.prefs.userContractCustomer];
    [self.txtContractCarrier setText:prefManager.prefs.userContractCarrier];
    	
	UIColor *color = [UIColor colorWithRed:16.0/255.0 green:79.0/255.0 blue:13.0/255.0 alpha:1];
	
    UIBarButtonItem *contractDeclineButton = [UIBarButtonItem barButtonItemWithTint:color andTitle:@"Отмена" andTarget:self andSelector:@selector(contractDecline:)];
    self.navigationItem.leftBarButtonItem = contractDeclineButton;
    
    if ([[SupTaxiAppDelegate sharedAppDelegate] currentOrderId] == nil) {        
        UIBarButtonItem *saveButton = [UIBarButtonItem barButtonItemWithTint:color andTitle:@"Сохранить" andTarget:self andSelector:@selector(contractSave:)];
        self.navigationItem.rightBarButtonItem = saveButton;
    } else
    {
        self.navigationItem.rightBarButtonItem = nil;
        [self showAlertMessage:@"Вы не можете изменить данные контракта пока у вас есть активный заказ!"];
    }    
    
	UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_header.png"]];
    img.backgroundColor = [UIColor clearColor];
	self.navigationItem.titleView = img;
	[img release];
	
	[self.navigationItem setHidesBackButton:YES];
}

- (void) contractSave:(id)sender{
	[self textFieldUnFocus];
	if ([self textFieldValidate] == NO) return;
    
    NSMutableDictionary * d = [NSMutableDictionary dictionaryWithCapacity:2];
    [d setValue:txtContractNumber.text forKey:CNUMB_KEY];
    [d setValue:txtContractCustomer.text forKey:CCUST_KEY];
    [d setValue:txtContractCarrier.text forKey:CCARR_KEY];
    
    [NSThread detachNewThreadSelector:@selector(UpdateThreadMethod:)
                             toTarget:self 
                           withObject:d];	
}
- (void) contractDecline:(id)sender{
	[self.navigationController popViewControllerAnimated:YES];
    if (self.delegate){
        [self.delegate performSelector:selectorOnDone];
    }
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
	[txtContractNumber release];
	[txtContractCustomer release];
	[txtContractCarrier release];
    [super dealloc];
}

-(void)textFieldUnFocus {
	[self.txtContractNumber resignFirstResponder];
	[self.txtContractCustomer resignFirstResponder];
	[self.txtContractCarrier resignFirstResponder];
}

-(BOOL)textFieldValidate {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Все поля обязательны для заполнения." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	NSArray *fieldArray;
	int i = 0;
	
	fieldArray = [[NSArray arrayWithObjects: 
				   [NSString stringWithFormat:@"%@",self.txtContractNumber.text],
				   [NSString stringWithFormat:@"%@",self.txtContractCustomer.text],
				   [NSString stringWithFormat:@"%@",self.txtContractCarrier.text],nil] retain];
	
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
