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

@interface SettingsViewController(Private)

- (IBAction)changeContractInfo:(id)sender;
- (IBAction)changeWishes:(id)sender;
- (IBAction)changeRegularOrder:(id)sender;
- (UIView*)headerViewWithText:(NSString*)text;

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

@synthesize tableView = tableView_;

#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
}

- (void)viewDidAppear:(BOOL)animated
{
	[tableView_ reloadData];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	prefManager = [SupTaxiAppDelegate sharedAppDelegate].prefManager;
	
	UIColor *color = [UIColor colorWithRed:16.0/255.0 green:79.0/255.0 blue:13.0/255.0 alpha:1];
	
	UIBarButtonItem *orderButton = [UIBarButtonItem barButtonItemWithTint:color andTitle:@"Сохранить" andTarget:self andSelector:@selector(saveSettings:)];
    self.navigationItem.rightBarButtonItem = orderButton;
    
	UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_header.png"]];
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
// высота каждой ячейки
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

// высота шапки
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
				[cell1.switcher addTarget:self action:@selector(changeWishes:) forControlEvents:UIControlEventValueChanged];
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
	self.userHasContract = result;
	if (result) {
		ContractViewController *contractViewController = [[ContractViewController alloc] initWithNibName:@"ContractViewController" bundle:nil];
		[self.navigationController pushViewController:contractViewController animated:YES];
		[contractViewController release];
	}
	NSLog(@"Sender Switch : %d", (int)result);
}

- (IBAction)changeWishes:(id)sender
{
	UICustomSwitch  *senderSwitch = (UICustomSwitch *)sender;
	BOOL result = [senderSwitch isOn];
	self.userHasWish = result;
	NSLog(@"Sender Switch : %d", (int)result);
}

- (IBAction)changeRegularOrder:(id)sender
{
	UICustomSwitch  *senderSwitch = (UICustomSwitch *)sender;
	BOOL result = [senderSwitch isOn];
	self.userHasRegularOrder = result;
	NSLog(@"Sender Switch : %d", (int)result);
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

					 
@end
