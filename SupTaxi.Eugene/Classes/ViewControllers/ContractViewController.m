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

@end

@implementation ContractViewController

@synthesize txtContractNumber;
@synthesize txtContractCustomer;
@synthesize txtContractCarrier;

#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	prefManager = [SupTaxiAppDelegate sharedAppDelegate].prefManager;
	
	UIColor *color = [UIColor colorWithRed:16.0/255.0 green:79.0/255.0 blue:13.0/255.0 alpha:1];
	
    UIBarButtonItem *saveButton = [UIBarButtonItem barButtonItemWithTint:color andTitle:@"Сохранить" andTarget:self andSelector:@selector(contractSave:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    UIBarButtonItem *contractDeclineButton = [UIBarButtonItem barButtonItemWithTint:color andTitle:@"Отмена" andTarget:self andSelector:@selector(contractDecline:)];
    self.navigationItem.leftBarButtonItem = contractDeclineButton;
    
	UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_header.png"]];
	self.navigationItem.titleView = img;
	[img release];
	
	[self.navigationItem setHidesBackButton:YES];
}

- (IBAction) contractSave:(id)sender{
	[self textFieldUnFocus];
	if ([self textFieldValidate] == NO) return;
	
}
- (IBAction) contractDecline:(id)sender{
	[self.navigationController popViewControllerAnimated:YES];
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