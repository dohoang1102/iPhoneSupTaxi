//
//  RegisterViewController.m
//  SupTaxi
//
//  Created by Eugene Zavalko on 30.08.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "RegisterViewController.h"
#import "BarButtonItemGreenColor.h"
#import "ServerResponce.h"
#import "AppProgress.h"
#import "SupTaxiAppDelegate.h"

#import "AddressViewController.h"
#import "HistoryViewController.h"

@interface RegisterViewController(Private)
 
- (void) RegisterThreadMethod:(id)obj;
- (void) AuthenticateThreadMethod:(id)obj;
- (void) RegisterResult:(id)obj;
- (void) AuthenticateResult:(id)obj;

- (void) showAlertMessage:(NSString *)alertMessage;

- (BOOL) textFieldValidate;
- (void) textFieldUnFocus;

- (void) ShowConnectionAlert:(id)obj;

@end

@implementation RegisterViewController

#define USER_EMAIL_KEY @"UEMAIL"
#define USER_PASSWORD_KEY @"UPASS"
#define USER_NAME_KEY @"UNAME"
#define USER_LNAME_KEY @"ULNAME"
#define USER_PHONE_KEY @"UPHONE"

@synthesize txtEmail;
@synthesize txtPassword;
@synthesize txtLastName;
@synthesize txtName;
@synthesize txtPhone;
@synthesize btnAccept;

@synthesize _registerResponse;
@synthesize _loginResponse;
@synthesize selectorOnDone;
@synthesize delegate;

#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	NSLog(@"REG FORM textField %@" , textField.text);
    [textField resignFirstResponder];
    return YES;
}

- (void) RegisterThreadMethod:(id)obj
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	AppProgress * progress = [AppProgress GetDefaultAppProgress];
	[progress StartProcessing:@"Регистрация"];
	
	
	ServerResponce * responce = [[ServerResponce alloc] init];
	if (responce) 
	{
		NSDictionary * d = (NSDictionary*)obj;
		NSString * email = [d objectForKey:USER_EMAIL_KEY];
		NSString * pass = [d objectForKey:USER_PASSWORD_KEY];
		NSString * name = [d objectForKey:USER_NAME_KEY];
		NSString * lName = [d objectForKey:USER_LNAME_KEY];
		NSString * phone = [d objectForKey:USER_PHONE_KEY];
		
		if ([responce RegisterUserRequest:email
								 password:pass
								firstName:name 
							   secondName:lName 
									phone:phone ])
		{
			NSArray * resultData = [responce GetDataItems];
			if (resultData) {
				self._registerResponse = [resultData objectAtIndex:0]; 
			}
			
			[self performSelectorOnMainThread:@selector(RegisterResult:) 
								   withObject:nil 
								waitUntilDone:NO];
		}else{
             [self performSelectorOnMainThread:@selector(ShowConnectionAlert:) 
                                    withObject:nil 
                                 waitUntilDone:NO];
        }
		[responce release];
	}
	
	
	[progress StopProcessing:@"Готово" andHideTime:0.5];
	
	[pool release];
}

- (void) AuthenticateThreadMethod:(id)obj
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	AppProgress * progress = [AppProgress GetDefaultAppProgress];
	[progress StartProcessing:@"Авторизация"];
	
	
	ServerResponce * responce = [[ServerResponce alloc] init];
	if (responce) 
	{
		NSDictionary * d = (NSDictionary*)obj;
		NSString * email = [d objectForKey:USER_EMAIL_KEY];
		NSString * pass = [d objectForKey:USER_PASSWORD_KEY];
		
		if ([responce LoginUserRequest:email password:pass ])
		{
			NSArray * resultData = [responce GetDataItems];
			if (resultData) {
				self._loginResponse = [resultData objectAtIndex:0]; 
			}
			
			[self performSelectorOnMainThread:@selector(AuthenticateResult:) 
								   withObject:nil 
								waitUntilDone:NO];
		}else{
            [self performSelectorOnMainThread:@selector(ShowConnectionAlert:) 
                                   withObject:nil 
                                waitUntilDone:NO];
        }

		[responce release];
	}
	
	
	[progress StopProcessing:@"Готово" andHideTime:0.5];
	
	[pool release];
}

- (void) RegisterResult:(id)obj
{
	if (!_registerResponse)
	{
		[self showAlertMessage:@"Ошибка запроса регистрации!"];
		return;
	}
	
	if (_registerResponse._result == NO) //ошибка регистрации:
	{
		[self showAlertMessage:@"Не удалось зарегистрироватся!"];
		return;	
	}
	else if (_registerResponse._result == YES) //зарегистрировались успешно
	{
		NSMutableDictionary * d = [NSMutableDictionary dictionaryWithCapacity:2];
		[d setValue:self.txtEmail.text forKey:USER_EMAIL_KEY];
		[d setValue:self.txtPassword.text forKey:USER_PASSWORD_KEY];
		
		[NSThread detachNewThreadSelector:@selector(AuthenticateThreadMethod:)
								 toTarget:self 
							   withObject:d];
		
		//[self showAlertMessage:@"Регистрация прошла успешно!"];
	}
}

- (void) ShowConnectionAlert:(id)obj
{
	[self showAlertMessage:@"Проверьте интернет соединение!"];
}

- (void) AuthenticateResult:(id)obj
{
	if (!_loginResponse)
	{
		[self showAlertMessage:@"Ошибка запроса авторизации!"];
		return;
	}
	
	if (_loginResponse._result == NO && _loginResponse._wrongPassword == NO) //неправильный ни email ни пароль:
	{
		NSMutableDictionary * d = [NSMutableDictionary dictionaryWithCapacity:5];
		[d setValue:self.txtEmail.text forKey:USER_EMAIL_KEY];
		[d setValue:self.txtName.text forKey:USER_NAME_KEY];
		[d setValue:self.txtLastName.text forKey:USER_LNAME_KEY];
		[d setValue:self.txtPassword.text forKey:USER_PASSWORD_KEY];
		[d setValue:self.txtPhone.text forKey:USER_PHONE_KEY];
		
		[NSThread detachNewThreadSelector:@selector(RegisterThreadMethod:)
								 toTarget:self 
							   withObject:d];	
	}
	else if (_loginResponse._result == NO && _loginResponse._wrongPassword == YES) //неправильный пароль
	{
		[self showAlertMessage:@"Проверьте правильность вашего пароля!"];
	}
	else if (_loginResponse._result == YES && _loginResponse._wrongPassword == NO) //правильный пароль и мыло
	{
		//TODO: Save userData
		[prefManager updateUserCredentialsWithEmail:txtEmail.text andPassword:txtPassword.text];
		[prefManager updateUserDataWithName:_loginResponse._firstName andSecondName:_loginResponse._secondName];
		[prefManager updateUserGuid:_loginResponse._guid];
		
        [prefManager updateUserHasContract:![_loginResponse._contractNumber isEqualToString:@""]];
        
        [prefManager updateUserContractWithNumber:_loginResponse._contractNumber 
                                 contractCustomer:_loginResponse._contractCustomer
                               andContractCarrier:_loginResponse._contractCarrier];
        [prefManager updateUserCity:_loginResponse._city];

        
		//[self showAlertMessage:@"Вы успешно авторизованы!"];
		//TODO: Get back to Order and send it
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
	
	UIColor *color = [UIColor colorWithRed:16.0/255.0 green:79.0/255.0 blue:13.0/255.0 alpha:1];
	
    UIBarButtonItem *registerButton = [UIBarButtonItem barButtonItemWithTint:color andTitle:@"Готово" andTarget:self andSelector:@selector(registerAction:)];
    self.navigationItem.rightBarButtonItem = registerButton;
    
    UIBarButtonItem *registerDeclineButton = [UIBarButtonItem barButtonItemWithTint:color andTitle:@"Отмена" andTarget:self andSelector:@selector(registerActionDecline:)];
    self.navigationItem.leftBarButtonItem = registerDeclineButton;
    
	UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_header.png"]];
    img.backgroundColor = [UIColor clearColor];
	self.navigationItem.titleView = img;
	[img release];
	
	[self.navigationItem setHidesBackButton:YES];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction) selectCheckBox:(id)sender
{
	UIButton *myButton = (UIButton*) sender;
	if (myButton.selected == YES)
	{	
		myButton.selected = NO;
	}else{
		myButton.selected = YES;
	}
	
}

- (IBAction)registerActionDecline:(id)sender
{
	NSLog(@"Delgate class: %@", [[self.delegate self] class]);
	if (self.delegate && ([[self.delegate self] isKindOfClass:[AddressViewController class]] || [[self.delegate self] isKindOfClass:[HistoryViewController class]])){
		UITabBarController * tc = [SupTaxiAppDelegate sharedAppDelegate].tabsController;
		[tc setSelectedIndex:3];
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)registerAction:(id)sender
{
	
	NSLog(@"REG FORM txtEmail %@" , txtEmail.text);
	
	[self textFieldUnFocus];
	if ([self textFieldValidate] == NO) return;
	/*
	if (self.btnAccept.selected == NO) {
		[self showAlertMessage:@"Не приняв условия регистрации Вы не можете быть зарегистрированным!"];
		return;
	}
	*/
	NSMutableDictionary * d = [NSMutableDictionary dictionaryWithCapacity:2];
	[d setValue:self.txtEmail.text forKey:USER_EMAIL_KEY];
	[d setValue:self.txtPassword.text forKey:USER_PASSWORD_KEY];
	
	[NSThread detachNewThreadSelector:@selector(AuthenticateThreadMethod:)
							 toTarget:self 
						   withObject:d];
	
}

-(void)textFieldUnFocus {
	[self.txtEmail resignFirstResponder];
	[self.txtPassword resignFirstResponder];
	[self.txtLastName resignFirstResponder];
	[self.txtName resignFirstResponder];
}

-(BOOL)textFieldValidate {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Поля, Логин и Пароль обязательны для заполнения." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	NSArray *fieldArray;
	int i = 0;
	
	fieldArray = [[NSArray arrayWithObjects: 
				   [NSString stringWithFormat:@"%@",self.txtEmail.text],
				   [NSString stringWithFormat:@"%@",self.txtPassword.text],nil] retain];
	
	@try {
		for (NSString *fieldText in fieldArray){
			if([fieldText isEqualToString:@""]){
				[alert show]; 
				return NO;
				break;
			}
			i++;
		}
		
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
        
        if (![emailTest evaluateWithObject:self.txtEmail.text])
        {
            [alert release];
            alert = [[UIAlertView alloc] initWithTitle:nil message:@"Логином является Email. Проверьте его правильность!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return NO;
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

- (void)dealloc {
	[txtEmail release];
	[txtPassword release];
	[txtLastName release];
	[txtName release];
	[txtPhone release];
	[btnAccept release];
	
	[_loginResponse release];
	[_registerResponse release];
	
	[super dealloc];
}


@end
