//
//  SettingsViewController.m
//  SupTaxi
//
//  Created by Eugene Zavalko on 04.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "SettingsViewController.h"
#import "BarButtonItemGreenColor.h"
#import "Response.h"
#import "SettingsCell.h"
#import "SettingsOrderCell.h"
#import "SupTaxiAppDelegate.h"
#import "ContractViewController.h"
#import "PreferredViewController.h"
#import "AppProgress.h"
#import "ServerResponce.h"

#define USER_EMAIL_KEY @"UEMAIL"
#define USER_PASSWORD_KEY @"UPASS"
#define USER_NAME_KEY @"UNAME"
#define USER_LNAME_KEY @"ULNAME"
#define USER_PHONE_KEY @"UPHONE"

@interface SettingsViewController(Private)

- (void) RegisterThreadMethod:(id)obj;
- (void) AuthenticateThreadMethod:(id)obj;
- (void) RegisterResult:(id)obj;
- (void) AuthenticateResult:(id)obj;

- (void) UpdateThreadMethod:(id)obj;
- (void) UpdateResult:(id)obj;

- (void) textFieldUnFocus;
- (BOOL) textFieldValidate;

- (IBAction) changeContractInfo:(id)sender;
- (IBAction) changeWishes:(id)sender;
- (IBAction) changeRegularOrder:(id)sender;
- (UIView*) headerViewWithText:(NSString*)text;
- (void) saveSettings:(id)sender;
- (void) showAlertMessage:(NSString *)alertMessage;
- (void) updateHasContract;
- (void) initPreferences;

@end


@implementation SettingsViewController

@synthesize supTaxiID;
@synthesize userFirstName;
@synthesize userSecondName;
@synthesize userPassword;
@synthesize userPhone;

@synthesize userHasContract;
@synthesize userHasWish;
@synthesize userHasRegularOrder;

@synthesize _registerResponse;
@synthesize _loginResponse;

@synthesize tableView = tableView_;

#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self.navigationItem setRightBarButtonItem:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
	
    int index = textField.tag;
	NSLog(@"Tag= %i", index);
	switch (index) {
		case 0:
			self.supTaxiID = textField.text;
			break;
		case 1:
			self.userFirstName = textField.text;
			break;
		case 2:
			self.userSecondName = textField.text;
			break;
		case 3:
			self.userPassword = textField.text;
			break;
		default:
			break;
	}
    UIColor *color = [UIColor colorWithRed:16.0/255.0 green:79.0/255.0 blue:13.0/255.0 alpha:1];
    UIBarButtonItem *saveButton = [UIBarButtonItem barButtonItemWithTint:color andTitle:@"Сохранить" andTarget:self andSelector:@selector(saveSettings:)];
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (void) UpdateThreadMethod:(id)obj
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	AppProgress * progress = [AppProgress GetDefaultAppProgress];
	[progress StartProcessing:@"Обновлене данных на сервере"];
	
	
	ServerResponce * responce = [[ServerResponce alloc] init];
	if (responce) 
	{
		
        NSDictionary * d = (NSDictionary*)obj;
		NSString * name = [d objectForKey:USER_NAME_KEY];
		NSString * lName = [d objectForKey:USER_LNAME_KEY];
        
		if ([responce UpdateUserRequest:prefManager.prefs.userGuid
                               password:prefManager.prefs.userPassword
                                  email:prefManager.prefs.userEmail
                              firstName:name
                             secondName:lName
                                   city:prefManager.prefs.userCity
                                cNumber:prefManager.prefs.userContractNumber
                              cCustomer:prefManager.prefs.userContractCustomer
                               cCarrier:prefManager.prefs.userContractCarrier
                                  phone:prefManager.prefs.userPhone])
		{
			NSArray * resultData = [responce GetDataItems];
			if (resultData) {
				self._registerResponse = [resultData objectAtIndex:0]; 
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
		}
		[responce release];
	}
	
	
	[progress StopProcessing:@"Готово" andHideTime:0.5];
	
	[pool release];
}

- (void) UpdateResult:(id)obj
{
	if (!_registerResponse)
	{
		[self showAlertMessage:@"Ошибка запроса обновления!"];
		return;
	}
	
	if (_registerResponse._result == NO) //ошибка обновления:
	{
		[self showAlertMessage:@"Не удалось обновить данные, попробуйте еще раз!"];
		return;	
	}
	else if (_registerResponse._result == YES) //все ок
	{
        [prefManager updateUserDataWithName:self.userFirstName andSecondName:self.userSecondName];
        [tableView_ reloadData];
    }
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
		[d setValue:self.supTaxiID forKey:USER_EMAIL_KEY];
		[d setValue:self.userPassword forKey:USER_PASSWORD_KEY];
		
		[NSThread detachNewThreadSelector:@selector(AuthenticateThreadMethod:)
								 toTarget:self 
							   withObject:d];
		
		//[self showAlertMessage:@"Регистрация прошла успешно!"];
	}
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
		[d setValue:self.supTaxiID forKey:USER_EMAIL_KEY];
		[d setValue:self.userFirstName forKey:USER_NAME_KEY];
		[d setValue:self.userSecondName forKey:USER_LNAME_KEY];
		[d setValue:self.userPassword forKey:USER_PASSWORD_KEY];
		[d setValue:self.userPhone forKey:USER_PHONE_KEY];
		
		[NSThread detachNewThreadSelector:@selector(RegisterThreadMethod:)
								 toTarget:self 
							   withObject:d];	
	}
	else if (_loginResponse._result == NO && _loginResponse._wrongPassword == YES) //неправильный пароль
	{
		[self showAlertMessage:@"Проверьте правильность вашего пароля!"];
	}
	else if (_loginResponse._result == YES && _loginResponse._wrongPassword == NO) //правильный пароль и мыло авторизовались удачно
	{
        //if first time login ok
        if ([prefManager.prefs.userGuid isEqualToString:@""] && [prefManager.prefs.userEmail isEqualToString:@""]) {
            //TODO: Save userData from server
            [prefManager updateUserCredentialsWithEmail:self.supTaxiID andPassword:self.userPassword];
            [prefManager updateUserGuid:_loginResponse._guid];
            [prefManager updateUserDataWithName:_loginResponse._firstName andSecondName:_loginResponse._secondName];
            [tableView_ reloadData];
        }
	}
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initPreferences];
	[tableView_ reloadData];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self initPreferences];
}

- (void) initPreferences
{
    prefManager = [SupTaxiAppDelegate sharedAppDelegate].prefManager;
	
    [self setUserPhone:prefManager.prefs.userPhone];
    
	UIColor *color = [UIColor colorWithRed:16.0/255.0 green:79.0/255.0 blue:13.0/255.0 alpha:1];
	
	UIBarButtonItem *orderButton = [UIBarButtonItem barButtonItemWithTint:color andTitle:@"Сохранить" andTarget:self andSelector:@selector(saveSettings:)];
    self.navigationItem.rightBarButtonItem = orderButton;
    
	UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_header.png"]];
    img.backgroundColor = [UIColor clearColor];
	self.navigationItem.titleView = img;
	[img release];
    
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
	
    // делаем невидимой кнопку назад
    [self.navigationItem setHidesBackButton:YES];
}

- (void) saveSettings:(id)sender
{
    [self textFieldUnFocus];
	if ([self textFieldValidate] == NO) return;
	
    //FirstTime RUN // no user data saved // try to login if no try to register and login again
    if ([prefManager.prefs.userGuid isEqualToString:@""] && [prefManager.prefs.userEmail isEqualToString:@""]) {
        
        NSMutableDictionary * d = [NSMutableDictionary dictionaryWithCapacity:2];
        [d setValue:self.supTaxiID forKey:USER_EMAIL_KEY];
        [d setValue:self.userPassword forKey:USER_PASSWORD_KEY];
        
        [NSThread detachNewThreadSelector:@selector(AuthenticateThreadMethod:)
                                 toTarget:self 
                               withObject:d];
        
        return;
    }
    
    //Already in system and just want to update user data
    if (![prefManager.prefs.userGuid isEqualToString:@""] && [prefManager.prefs.userEmail isEqualToString:self.supTaxiID]) {
        NSMutableDictionary * d = [NSMutableDictionary dictionaryWithCapacity:2];
		[d setValue:self.userFirstName forKey:USER_NAME_KEY];
		[d setValue:self.userSecondName forKey:USER_LNAME_KEY];
		
		[NSThread detachNewThreadSelector:@selector(UpdateThreadMethod:)
								 toTarget:self 
							   withObject:d];
        return;
    }
    
    //LogedIn but trying to change user
    if (![prefManager.prefs.userGuid isEqualToString:@""] && ![prefManager.prefs.userEmail isEqualToString:self.supTaxiID]) {
        
        //Before login with new user we need to clear data with old user
        [prefManager initFields];
        
        NSMutableDictionary * d = [NSMutableDictionary dictionaryWithCapacity:2];
        [d setValue:self.supTaxiID forKey:USER_EMAIL_KEY];
        [d setValue:self.userPassword forKey:USER_PASSWORD_KEY];
        
        [NSThread detachNewThreadSelector:@selector(AuthenticateThreadMethod:)
                                 toTarget:self 
                               withObject:d];
        
        return;
    }
    
}

-(void)textFieldUnFocus {
	[self resignFirstResponder];
}

-(BOOL)textFieldValidate {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Поле \"SupTaxi ID\" и \"Пароль\" обязательны для заполнения." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	NSArray *fieldArray;
	int i = 0;
	
	fieldArray = [[NSArray arrayWithObjects: 
				   [NSString stringWithFormat:@"%@",self.supTaxiID],
				   [NSString stringWithFormat:@"%@",self.userPassword],nil] retain];
	
	@try {
		for (NSString *fieldText in fieldArray){
			if([fieldText isEqualToString:@"(null)"] || [fieldText isEqualToString:@""]){
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
	[supTaxiID release];
	[userFirstName release];
	[userSecondName release];
	[userPassword release];
	[userPhone release];
	
	[tableView_ release];
	
    [super dealloc];
}

#pragma mark -
#pragma UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section 
{
	return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{   
	switch (section) {
		case 0:
		{
			return [self headerViewWithText: @"Личные данные"];
			break;		
        }
		case 3:
		{
			return [self headerViewWithText: @"Настройка заказа"];
			break;
		}
	}
    return nil;
}

#pragma mark -
#pragma UITableViewDataSourceDelegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) {
		case 1:
			return 3;
			break;
		default:
			return 1;
			break;
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int section = indexPath.section;
	int row = indexPath.row;

	NSLog(@"Section: %i Row: %i", section, row);
	if (section >= 0 && section <= 2 ) {
		SettingsCell *cell = (SettingsCell *)[tableView dequeueReusableCellWithIdentifier:@"CellId"];
		if (cell == nil) {
			cell = [[[SettingsCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"CellId"] autorelease];        
		}
				
		switch (section) {
			case 0:
				cell.titleLabel.text = @"SupTaxi ID";
				cell.textField.delegate = self;
				cell.textField.tag = 0;
				[cell.textField setText:prefManager.prefs.userEmail];
				return cell;
				break;
			case 1:
				if (row == 0) {
					cell.titleLabel.text = @"Имя";
					cell.textField.tag = 1;
					cell.textField.delegate = self;
					[cell.textField setText:prefManager.prefs.userFirstName];
				}else if (row == 1) {
					cell.titleLabel.text = @"Фамилия";
					cell.textField.tag = 2;
					cell.textField.delegate = self;
					[cell.textField setText:prefManager.prefs.userSecondName];
				}else if (row == 2) {
					cell.titleLabel.text = @"Пароль";
					[cell.textField setSecureTextEntry:YES];
					cell.textField.tag = 3;
					cell.textField.delegate = self;
					[cell.textField setText:prefManager.prefs.userPassword];
				}
				return cell;
				break;
			case 2:
				cell.titleLabel.text = @"Телефон";
				[cell.textField setEnabled:NO];
                [cell.textField setText:prefManager.prefs.userPhone];
				return cell;
				break;
		}
		
	}else {
		SettingsOrderCell *cell1 = (SettingsOrderCell *)[tableView dequeueReusableCellWithIdentifier:@"CellId"];
		if (cell1 == nil) {
			cell1 = [[[SettingsOrderCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"CellId"] autorelease];        
		}
		
		switch (section) {
			case 3:
				cell1.titleLabel.text = @"№ договора";
				[cell1.switcher addTarget:self action:@selector(changeContractInfo:) forControlEvents:UIControlEventValueChanged];
				[cell1.switcher setOn:prefManager.prefs.userHasContract];
				return cell1;
				break;
			case 4:
				cell1.titleLabel.text = @"Предпочтения";
				[cell1.switcher addTarget:self action:@selector(changePreferred:) forControlEvents:UIControlEventValueChanged];
				[cell1.switcher setOn:prefManager.prefs.userHasPrefered];
				return cell1;
				break;
			case 5:
				cell1.titleLabel.text = @"Регулярный заказ";
				[cell1.switcher addTarget:self action:@selector(changeRegularOrder:) forControlEvents:UIControlEventValueChanged];
				[cell1.switcher setOn:prefManager.prefs.userHasRegularOrder];
				return cell1;
				break;
		}
	}
	return nil;
}

- (IBAction)changeContractInfo:(id)sender
{
	UICustomSwitch  *senderSwitch = (UICustomSwitch *)sender;
	BOOL result = [senderSwitch isOn];
	if ([prefManager.prefs.userGuid isEqualToString:@""]) {
		[self showAlertMessage:@"Вы не можете добавить информацию о контракте пока Вы не сохранили настройки и не авторизовались в систему!"];
		[senderSwitch setOn:NO];
		return;
	}
	
	self.userHasContract = result;
	if (result) {
		ContractViewController *contractViewController = [[ContractViewController alloc] initWithNibName:@"ContractViewController" bundle:nil];
        contractViewController.delegate = self;
		contractViewController.selectorOnDone = @selector(updateHasContract);
		[self.navigationController pushViewController:contractViewController animated:YES];
		[contractViewController release];
	}
}

- (void) updateHasContract {
    [self.tableView reloadData];
}

- (IBAction)changePreferred:(id)sender
{
	UICustomSwitch  *senderSwitch = (UICustomSwitch *)sender;
    [senderSwitch setOn:YES];
	BOOL result = [senderSwitch isOn];
	if ([prefManager.prefs.userGuid isEqualToString:@""]) {
		[self showAlertMessage:@"Вы не можете выбрать предпочетаемые компании пока Вы не сохранили настройки и не авторизовались в систему!"];
		[senderSwitch setOn:NO];
		return;
	}
	self.userHasWish = result;
	
	if (result) {
		PreferredViewController *pViewController = [[PreferredViewController alloc] initWithNibName:@"PreferredViewController" bundle:nil];
        [self.navigationController pushViewController:pViewController animated:YES];
		[pViewController release];
	}
}



- (IBAction)changeRegularOrder:(id)sender
{
	UICustomSwitch  *senderSwitch = (UICustomSwitch *)sender;
	BOOL result = [senderSwitch isOn];
	
	self.userHasRegularOrder = result;
}

-(UIView*)headerViewWithText:(NSString*)text
{
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
	UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    newLabel.textAlignment = UITextAlignmentLeft;
    newLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
	newLabel.textColor = [UIColor whiteColor];
    newLabel.backgroundColor = [UIColor clearColor];
    newLabel.opaque = YES;	
	newLabel.frame = CGRectMake(10, 0, headerView.frame.size.width-20, headerView.frame.size.height);
	newLabel.text = text;
	[headerView addSubview:newLabel];
	[newLabel release];
	return [headerView autorelease];
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
